import CoreData

protocol StoreMigrating {
    var destinationVersion: Int { get }

    func migrate(from sourceURL: URL, to destinationURL: URL,
                 sourceModel: NSManagedObjectModel, destinationModel: NSManagedObjectModel) throws
}

enum MigrationError: Error {
    case missingModel(String)
    case unsupportedStoreVersion
    case invalidModelCopy
}

class StoreMigrationManager {
    
    let migrations: [any StoreMigrating] = [
        StoreMigrationV3()
    ]
    
    private let currentModel: Int = 3
    
    func migrateIfNeeded(at storeURL: URL, bundle: Bundle = .main) throws {
        guard FileManager.default.fileExists(atPath: storeURL.path) else { return }
        let destinationModel = try model(version: currentModel, bundle: bundle)
        let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(
            ofType: NSSQLiteStoreType, at: storeURL, options: [NSReadOnlyPersistentStoreOption: true]
        )
        guard !destinationModel.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata) else {
            return
        }
        
        let sourceModel = try model(version: 2, bundle: bundle)
        guard sourceModel.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata) else {
            throw MigrationError.unsupportedStoreVersion
        }

        try migrate(at: storeURL, from: sourceModel, to: destinationModel)
    }
    
    func model(version: Int, bundle: Bundle) throws -> NSManagedObjectModel {
        let name = "Backend \(version)"
        guard let directory = bundle.url(forResource: "D2AModel", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: directory.appendingPathComponent(name + ".mom")) else {
            throw MigrationError.missingModel(name)
        }
        return model
    }
    
    func migrate(
        at storeURL: URL,
        from sourceModel: NSManagedObjectModel,
        to destinationModel: NSManagedObjectModel
    ) throws {
        let temporaryDirectory = storeURL.deletingLastPathComponent()
            .appendingPathComponent("Migration-" + UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: temporaryDirectory) }
        let destinationURL = temporaryDirectory.appendingPathComponent("D2AModel.sqlite")

        guard let migration = migrations.first(where: { $0.destinationVersion == currentModel }) else {
            throw MigrationError.unsupportedStoreVersion
        }
        try migration.migrate(
            from: storeURL, to: destinationURL,
            sourceModel: sourceModel, destinationModel: destinationModel
        )

        // Core Data replaces the SQLite store and its sidecars together.
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: destinationModel)
        try coordinator.replacePersistentStore(
            at: storeURL, destinationOptions: nil,
            withPersistentStoreFrom: destinationURL, sourceOptions: nil, ofType: NSSQLiteStoreType
        )
    }
    
}
