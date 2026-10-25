import CoreData
import XCTest
@testable import D2A

final class RecentMatchStoreMigrationTests: XCTestCase {
    func testDeduplicationAndMigrationPreserveOtherPlayersAndAreRepeatable() throws {
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("test.sqlite")
        let source = makeModel()
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: source)
        let store = try coordinator.addPersistentStore(ofType: NSSQLiteStoreType,
                                                       configurationName: nil, at: url)
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        try context.performAndWait {
            for (player, match, time) in [("a", "1", 1.0), ("a", "1", 2.0),
                                          ("b", "1", 1.0), ("a", "2", 1.0)] {
                let object = NSEntityDescription.insertNewObject(forEntityName: "RecentMatch", into: context)
                object.setValue(player, forKey: "playerId")
                object.setValue(match, forKey: "id")
                object.setValue(Date(timeIntervalSince1970: time), forKey: "startTime")
            }
            try context.save()
            context.reset()
        }
        try coordinator.remove(store)
        try RecentMatchStoreMigration.removeDuplicates(at: url, sourceModel: source)
        try RecentMatchStoreMigration.removeDuplicates(at: url, sourceModel: source)

        let destination = makeModel()
        destination.entities[0].uniquenessConstraints = [["playerId", "id"]]
        let migratedCoordinator = NSPersistentStoreCoordinator(managedObjectModel: destination)
        let migratedStore = try migratedCoordinator.addPersistentStore(
            ofType: NSSQLiteStoreType, configurationName: nil, at: url,
            options: [NSMigratePersistentStoresAutomaticallyOption: true,
                      NSInferMappingModelAutomaticallyOption: true])
        let migratedContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        migratedContext.persistentStoreCoordinator = migratedCoordinator
        try migratedContext.performAndWait {
            let objects = try migratedContext.fetch(NSFetchRequest<NSManagedObject>(entityName: "RecentMatch"))
            XCTAssertEqual(objects.count, 3)
            let survivor = objects.first {
                $0.value(forKey: "playerId") as? String == "a" && $0.value(forKey: "id") as? String == "1"
            }
            XCTAssertEqual(survivor?.value(forKey: "startTime") as? Date, Date(timeIntervalSince1970: 2))
            migratedContext.reset()
        }
        try migratedCoordinator.remove(migratedStore)
        // Once migrated, no historical model lookup is necessary.
        try RecentMatchStoreMigration.prepareStore(at: url, destinationModel: destination, bundles: [])
    }

    private func makeModel() -> NSManagedObjectModel {
        let entity = NSEntityDescription()
        entity.name = "RecentMatch"
        entity.managedObjectClassName = "NSManagedObject"
        let attributes: [(String, NSAttributeType)] = [("playerId", .stringAttributeType),
                                                       ("id", .stringAttributeType), ("startTime", .dateAttributeType)]
        entity.properties = attributes.map { name, type in
            let attribute = NSAttributeDescription()
            attribute.name = name
            attribute.attributeType = type
            return attribute
        }
        let model = NSManagedObjectModel()
        model.entities = [entity]
        return model
    }
}
