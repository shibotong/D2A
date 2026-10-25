import CoreData

/// Cleans the source store before automatic migration adds RecentMatch's unique constraint.
nonisolated
enum RecentMatchStoreMigration {
    static func prepareStore(at url: URL, destinationModel: NSManagedObjectModel,
                             bundles: [Bundle] = [.main]) throws {
        guard FileManager.default.fileExists(atPath: url.path) else { return }
        let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(
            ofType: NSSQLiteStoreType, at: url, options: nil)
        guard !destinationModel.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata) else {
            return
        }
        guard let sourceModel = NSManagedObjectModel.mergedModel(from: bundles, forStoreMetadata: metadata) else {
            throw MigrationError.sourceModelNotFound
        }
        try removeDuplicates(at: url, sourceModel: sourceModel)
    }

    static func removeDuplicates(at url: URL, sourceModel: NSManagedObjectModel) throws {
        // Historical entities may no longer have Swift classes in the current app.
        let model = sourceModel.copy() as! NSManagedObjectModel
        for entity in model.entities {
            entity.managedObjectClassName = "NSManagedObject"
        }
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        let store = try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                       configurationName: nil, at: url,
                                                       options: [NSMigratePersistentStoresAutomaticallyOption: false])
        do {
            let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
            context.persistentStoreCoordinator = coordinator
            try context.performAndWait {
                let request = NSFetchRequest<NSManagedObject>(entityName: "RecentMatch")
                request.fetchBatchSize = 500
                // Keep the newest record; use its permanent object ID to break ties consistently.
                request.sortDescriptors = [NSSortDescriptor(key: "startTime", ascending: false)]
                var survivors: [MatchKey: NSManagedObject] = [:]
                for match in try context.fetch(request) {
                    let key = MatchKey(playerID: match.value(forKey: "playerId") as? String,
                                       matchID: match.value(forKey: "id") as? String)
                    if let survivor = survivors[key] {
                        let date = match.value(forKey: "startTime") as? Date
                        let survivorDate = survivor.value(forKey: "startTime") as? Date
                        if date == survivorDate,
                           match.objectID.uriRepresentation().absoluteString < survivor.objectID.uriRepresentation().absoluteString {
                            context.delete(survivor)
                            survivors[key] = match
                        } else {
                            context.delete(match)
                        }
                    } else {
                        survivors[key] = match
                    }
                }
                if context.hasChanges { try context.save() }
                context.reset()
            }
        } catch {
            try? coordinator.remove(store)
            throw error
        }
        try coordinator.remove(store)
    }

    private struct MatchKey: Hashable {
        let playerID: String?
        let matchID: String?
    }

    enum MigrationError: Error {
        case sourceModelNotFound
    }
}
