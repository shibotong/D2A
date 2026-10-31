import CoreData

protocol StoreMigrating {
    
    var sourceVersion: Int { get }
    
    var destinationModel: NSManagedObjectModel { get }
    
    var sourceModel: NSManagedObjectModel { get }

    func migrate(from sourceURL: URL, to destinationURL: URL) throws -> NSManagedObjectModel
    
    func needMigration(metadata: [String: Any]) -> Bool
}

extension StoreMigrating {
    var destinationVersion: Int {
        return sourceVersion + 1
    }
}

enum MigrationError: Error {
    case missingModel(String)
    case unsupportedStoreVersion
    case invalidModelCopy
}

class StoreMigrationManager {
    
    static func model(version: Int, bundle: Bundle) throws -> NSManagedObjectModel {
        let name = "Backend \(version)"
        guard let directory = bundle.url(forResource: "D2AModel", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: directory.appendingPathComponent(name + ".mom")) else {
            throw MigrationError.missingModel(name)
        }
        return model
    }
    
    let migrations: [any StoreMigrating] = [
        StoreMigrationV3()
    ]
    
    private let currentModel: Int = 3
    
    private let fileManager: FileManager
    private let storeURL: URL
    private let bundle: Bundle
    private let logger: D2ALogger
    
    init(storeURL: URL, fileManager: FileManager = .default, bundle: Bundle = .main, logger: D2ALogger = .shared) {
        self.storeURL = storeURL
        self.fileManager = fileManager
        self.bundle = bundle
        self.logger = logger
    }
    
    func migrateIfNeeded() throws {
        logger.debug("Start CoreData migrating...", category: .coreData)
        guard fileManager.fileExists(atPath: storeURL.path) else {
            logger.notice("CoreData store doesn't exist at \(storeURL.path). Create a new file...", category: .coreData)
            return
        }
        
        let destinationModel = try Self.model(version: currentModel, bundle: bundle)
        
        let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(
            ofType: NSSQLiteStoreType, at: storeURL, options: [NSReadOnlyPersistentStoreOption: true]
        )
        
        logger.notice("Metadata is not compatible with current store version (version \(currentModel)). Needs migration...", category: .coreData)
        var migrationSteps: [any StoreMigrating] = []
        
        for migration in migrations {
            if migration.needMigration(metadata: metadata) {
                logger.notice("Metadata is not compatible with model version \(migration.destinationVersion), needs migration...", category: .coreData)
                migrationSteps.insert(migration, at: 0)
            } else {
                logger.notice("Metadata is compatible with model version \(migration.destinationVersion). Stop checking...", category: .coreData)
                break
            }
        }
        
        try migrationSteps.forEach { try migrateStore(step: $0) }
    }
    
    private func migrateStore(step: any StoreMigrating) throws {
        let temporaryDirectory = try copyStore()
        defer {
            logger.debug("Removing temporary create store for migration...", category: .coreData)
            try? fileManager.removeItem(at: temporaryDirectory)
        }
        let destinationURL = temporaryDirectory.appendingPathComponent("D2AModel.sqlite")
        
        let destinationModel = try step.migrate(from: storeURL, to: destinationURL)
        
        // Core Data replaces the SQLite store and its sidecars together.
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: destinationModel)
        try coordinator.replacePersistentStore(
            at: storeURL, destinationOptions: nil,
            withPersistentStoreFrom: destinationURL, sourceOptions: nil, ofType: NSSQLiteStoreType
        )
    }
    
    private func copyStore() throws -> URL {
        logger.debug("Copying current store for migration...", category: .coreData)
        let temporaryDirectory = storeURL.deletingLastPathComponent()
            .appendingPathComponent("Migration-" + UUID().uuidString, isDirectory: true)
        try fileManager.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true)
        return temporaryDirectory
    }
}
