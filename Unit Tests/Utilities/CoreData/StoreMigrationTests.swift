import CoreData
import Testing
@testable import D2A

struct StoreMigrationTests {
    @Test
    func rejectsVersion1WithoutChangingStore() throws {
        let bundle = Bundle(for: PersistenceProvider.self)
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let modelDirectory = try #require(bundle.url(forResource: "D2AModel", withExtension: "momd"))
        let source = try #require(NSManagedObjectModel(contentsOf: modelDirectory.appendingPathComponent("Backend.mom")))
        let url = directory.appendingPathComponent("test.sqlite")
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: source)
        let store = try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url)
        try coordinator.remove(store)

        #expect(throws: MigrationError.self) {
            try StoreMigrationManager().migrateIfNeeded(at: url, bundle: bundle)
        }
        let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: url)
        #expect(source.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata))
    }

    @Test
    func preservesRenamedValuesRelationshipsAndDeduplicates() throws {
        let migration = StoreMigrationManager()
        let bundle = Bundle(for: PersistenceProvider.self)
        let source = try migration.model(version: 2, bundle: bundle)
        let destination = try migration.model(version: 3, bundle: bundle)
        // Use generic managed objects so fixtures can still write version 2 attribute names.
        for entity in source.entities { entity.managedObjectClassName = "NSManagedObject" }
        for entity in destination.entities { entity.managedObjectClassName = "NSManagedObject" }
        let directory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: directory) }
        let url = directory.appendingPathComponent("test.sqlite")
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: source)
        let store = try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url)
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.persistentStoreCoordinator = coordinator
        try context.performAndWait {
            func insert(_ name: String, _ values: [String: Any]) -> NSManagedObject {
                let object = NSEntityDescription.insertNewObject(forEntityName: name, into: context)
                object.setValuesForKeys(values)
                return object
            }
            let oldHero = insert("Hero", ["id": 42.0, "lastFetch": Date(timeIntervalSince1970: 1), "name": "old"])
            let hero = insert("Hero", ["id": 42.0, "lastFetch": Date(timeIntervalSince1970: 2), "name": "new"])
            let ability = insert("Ability", ["abilityID": 123])
            let secondAbility = insert("Ability", ["abilityID": 124])
            hero.setValue(NSOrderedSet(array: [ability, secondAbility]), forKey: "abilities")
            let role = insert("Role", ["level": 2.0])
            role.setValue(oldHero, forKey: "hero")
            let translation = insert("AbilityTranslation", ["abilityID": 123, "name": "test", "language": "english", "attributes": ["test"]])
            translation.setValue(ability, forKey: "ability")
            let removed = insert("HeroTranslation", ["heroID": 42, "language": "english"])
            removed.setValue(hero, forKey: "hero")
            _ = insert("Match", ["id": "900", "goldDiff": [NSNumber(value: 10)]])
            _ = insert("UserProfile", [
                "id": "7", "avatarfull": "c",
                "personaname": "Player", "favourite": true, "register": true
            ])
            for player in ["7", "7", "8"] {
                _ = insert("RecentMatch", ["id": "900", "playerId": player, "heroID": 42])
            }
            try context.save()
            context.reset()
        }
        try coordinator.remove(store)

        let invalidDestination = try migration.model(version: 3, bundle: bundle)
        let required = NSAttributeDescription()
        required.name = "requiredMigrationTestValue"
        required.attributeType = .stringAttributeType
        required.isOptional = false
        let invalidHero = try #require(invalidDestination.entitiesByName["Hero"])
        invalidHero.properties.append(required)
        #expect(throws: (any Error).self) {
            try migration.migrate(at: url, from: source, to: invalidDestination)
        }
        let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(ofType: NSSQLiteStoreType, at: url)
        #expect(source.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata))

        try migration.migrateIfNeeded(at: url, bundle: bundle)
        // Reopening an already migrated store must be a no-op.
        try migration.migrateIfNeeded(at: url, bundle: bundle)
        let migrated = NSPersistentStoreCoordinator(managedObjectModel: destination)
        let migratedStore = try migrated.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url)
        defer { try? migrated.remove(migratedStore) }
        let result = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        result.persistentStoreCoordinator = migrated
        try result.performAndWait {
            func fetch(_ name: String) throws -> [NSManagedObject] {
                try result.fetch(NSFetchRequest<NSManagedObject>(entityName: name))
            }
            let heroes = try fetch("Hero")
            #expect(heroes.count == 1)
            let hero = try #require(heroes.first)
            #expect(hero.value(forKey: "heroId") as? Double == 42)
            #expect(hero.value(forKey: "name") as? String == "new")
            let abilities = try #require(hero.value(forKey: "abilities") as? NSOrderedSet)
            #expect(abilities.count == 2)
            #expect((abilities.firstObject as? NSManagedObject)?.value(forKey: "abilityId") as? Int == 123)
            #expect((hero.value(forKey: "roles") as? NSSet)?.count == 1)
            let translation = try #require(fetch("AbilityTranslation").first)
            #expect(translation.value(forKey: "abilityId") as? Int == 123)
            #expect(translation.value(forKey: "attributes") as? [String] == ["test"])
            #expect(translation.value(forKey: "ability") != nil)
            let match = try #require(fetch("Match").first)
            #expect(match.value(forKey: "matchId") as? String == "900")
            #expect(match.value(forKey: "goldDiff") as? [NSNumber] == [NSNumber(value: 10)])
            let user = try #require(fetch("UserProfile").first)
            #expect(user.value(forKey: "userId") as? String == "7")
            #expect(user.value(forKey: "favourite") as? Bool == true)
            let recent = try fetch("RecentMatch")
            #expect(recent.count == 2)
            #expect(recent.allSatisfy { $0.value(forKey: "matchId") as? String == "900" })
            #expect(recent.allSatisfy { $0.value(forKey: "heroId") as? Int == 42 })
            #expect(destination.entitiesByName["HeroTranslation"] == nil)
            result.reset()
        }
    }
}
