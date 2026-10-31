import Foundation
import CoreData

/// Manually copies a version 2 store into the version 3 schema.
nonisolated
class StoreMigrationV3: StoreMigrating {
    
    let sourceVersion: Int = 2

    private let renamedAttributes = [
        "Ability": ["abilityId": "abilityID"],
        "AbilityTranslation": ["abilityId": "abilityID"],
        "Hero": ["heroId": "id"],
        "Match": ["matchId": "id"],
        "RecentMatch": ["heroId": "heroID", "matchId": "id"],
        "UserProfile": ["userId": "id"]
    ]
    
    lazy var sourceModel: NSManagedObjectModel = {
        return try! StoreMigrationManager.model(version: sourceVersion, bundle: bundle)
    }()
    
    lazy var destinationModel: NSManagedObjectModel = {
        return try! StoreMigrationManager.model(version: destinationVersion, bundle: bundle)
    }()
    
    private let bundle: Bundle
    private let logger: D2ALogger
    
    init(bundle: Bundle = .main, logger: D2ALogger = .shared) {
        self.bundle = bundle
        self.logger = logger
    }
    
    /// The store needs migration from this version
    func needMigration(metadata: [String: Any]) -> Bool {
        logger.debug("Checking store is compatible with model version \(destinationVersion)...", category: .coreData)
        return destinationModel.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata)
    }
    
    /// Copies legacy stores into a separate store, leaving the source untouched until saving succeeds.
    func migrate(
        from sourceURL: URL, to destinationURL: URL
    ) throws -> NSManagedObjectModel {
        logger.info("Migrating store from model version \(sourceVersion), to \(destinationVersion)", category: .coreData)
        // Legacy keys must be accessed through KVC, not the generated version 3 subclasses.
        let sourceModel = try plainModel(sourceModel)
        let destinationModel = try plainModel(destinationModel)
        let sourceCoordinator = NSPersistentStoreCoordinator(managedObjectModel: sourceModel)
        let destinationCoordinator =  NSPersistentStoreCoordinator(managedObjectModel: destinationModel)
        let sourceStore = try sourceCoordinator.addPersistentStore(
            ofType: NSSQLiteStoreType, configurationName: nil, at: sourceURL,
            options: [NSReadOnlyPersistentStoreOption: true]
        )
        defer { try? sourceCoordinator.remove(sourceStore) }
        let destinationStore = try destinationCoordinator.addPersistentStore(
            ofType: NSSQLiteStoreType, configurationName: nil, at: destinationURL
        )
        defer { try? destinationCoordinator.remove(destinationStore) }

        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = sourceCoordinator
        // Snapshots are immutable and transferred only after the source queue finishes reading.
        struct Snapshot: @unchecked Sendable {
            let id: NSManagedObjectID
            let entityName: String
            let attributes: [String: Any]
            let relationships: [String: [NSManagedObjectID]]
        }
        let entityNames = destinationModel.entities.compactMap(\.name)
        let snapshots: [Snapshot] = try context.performAndWait {
            var snapshots: [Snapshot] = []
            for name in entityNames {
                guard sourceCoordinator.managedObjectModel.entitiesByName[name] != nil else { continue }
                let request = NSFetchRequest<NSManagedObject>(entityName: name)
                var objects = try context.fetch(request)
                // Prefer the newest hero snapshot; break ties consistently across retries.
                objects.sort {
                    if name == "Hero" {
                        let left = $0.value(forKey: "lastFetch") as? Date ?? .distantPast
                        let right = $1.value(forKey: "lastFetch") as? Date ?? .distantPast
                        if left != right { return left > right }
                    }
                    return $0.objectID.uriRepresentation().absoluteString < $1.objectID.uriRepresentation().absoluteString
                }
                for source in objects {
                    var relationships: [String: [NSManagedObjectID]] = [:]
                    for (key, relationship) in source.entity.relationshipsByName {
                        if relationship.isToMany {
                            let related: [NSManagedObject]
                            if relationship.isOrdered {
                                related = (source.value(forKey: key) as? NSOrderedSet)?.array as? [NSManagedObject] ?? []
                            } else {
                                related = (source.value(forKey: key) as? NSSet)?.allObjects as? [NSManagedObject] ?? []
                            }
                            relationships[key] = related.map(\.objectID)
                        } else {
                            relationships[key] = (source.value(forKey: key) as? NSManagedObject).map { [$0.objectID] } ?? []
                        }
                    }
                    snapshots.append(Snapshot(
                        id: source.objectID, entityName: name,
                        attributes: source.dictionaryWithValues(forKeys: Array(source.entity.attributesByName.keys)),
                        relationships: relationships
                    ))
                }
            }
            context.reset()
            return snapshots
        }

        let destinationContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        destinationContext.persistentStoreCoordinator = destinationCoordinator
        try destinationContext.performAndWait {
            var destinations: [NSManagedObjectID: NSManagedObject] = [:]
            for entity in destinationCoordinator.managedObjectModel.entities {
                guard let name = entity.name else { continue }
                var uniqueObjects: [NSArray: NSManagedObject] = [:]
                for source in snapshots where source.entityName == name {
                    let key: NSArray?
                    switch name {
                    case "Hero":
                        key = [source.attributes["id"] ?? NSNull()] as NSArray
                    case "RecentMatch":
                        key = [source.attributes["playerId"] ?? NSNull(), source.attributes["id"] ?? NSNull()] as NSArray
                    default:
                        key = nil
                    }
                    let existing = key.flatMap { uniqueObjects[$0] }
                    let destination = existing ?? NSManagedObject(entity: entity, insertInto: destinationContext)
                    for attribute in entity.attributesByName.keys {
                        let oldName = renamedAttributes[name]?[attribute] ?? attribute
                        guard let value = source.attributes[oldName] else { continue }
                        // For duplicate rows, retain the preferred row and fill any missing optional values.
                        if existing == nil || destination.value(forKey: attribute) == nil {
                            destination.setValue(value is NSNull ? nil : value, forKey: attribute)
                        }
                    }
                    if let key { uniqueObjects[key] = destination }
                    destinations[source.id] = destination
                }
            }

            // Create relationships only after every source object has a destination.
            // HeroTranslation and Hero.localizations are intentionally absent from version 3.
            var orderedRelationships: [NSManagedObjectID: [String: NSMutableOrderedSet]] = [:]
            for source in snapshots {
                guard let destination = destinations[source.id] else { continue }
                for (name, relationship) in destination.entity.relationshipsByName {
                    guard let related = source.relationships[name] else { continue }
                    let mapped = related.compactMap { destinations[$0] }
                    if relationship.isToMany {
                        if relationship.isOrdered {
                            let ordered = orderedRelationships[destination.objectID]?[name] ?? NSMutableOrderedSet()
                            ordered.addObjects(from: mapped)
                            orderedRelationships[destination.objectID, default: [:]][name] = ordered
                        } else {
                            destination.mutableSetValue(forKey: name).addObjects(from: mapped)
                        }
                    } else if destination.value(forKey: name) == nil {
                        destination.setValue(mapped.first, forKey: name)
                    }
                }
            }
            // Inverse to-one assignments may populate ordered sets in arbitrary order.
            // Apply the source order last, retaining the preferred hero's order before merged extras.
            for (id, relationships) in orderedRelationships {
                let destination = destinationContext.object(with: id)
                for (name, ordered) in relationships {
                    destination.setValue(ordered, forKey: name)
                }
            }
            try destinationContext.save()
            destinationContext.reset()
        }
        try destinationCoordinator.remove(destinationStore)
        try sourceCoordinator.remove(sourceStore)
        logger.info("Finish migrating store from model version \(sourceVersion), to \(destinationVersion)", category: .coreData)
        return destinationModel
    }

    private func plainModel(_ model: NSManagedObjectModel) throws -> NSManagedObjectModel {
        guard let copy = model.copy() as? NSManagedObjectModel else {
            throw MigrationError.invalidModelCopy
        }
        for entity in copy.entities {
            entity.managedObjectClassName = NSStringFromClass(NSManagedObject.self)
        }
        return copy
    }
}
