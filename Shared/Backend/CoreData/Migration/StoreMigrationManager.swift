import CoreData

nonisolated
protocol StoreMigrating {
    
    var sourceVersion: Int { get }
    
    var destinationModel: NSManagedObjectModel { get throws }
    
    var sourceModel: NSManagedObjectModel { get throws }

    func migrate(from sourceURL: URL, to destinationURL: URL) throws -> NSManagedObjectModel
    
}

extension StoreMigrating {
    nonisolated
    var destinationVersion: Int {
        return sourceVersion + 1
    }
}

enum MigrationError: Error, Equatable {
    case missingModel(String)
    case unsupportedStoreVersion
    case invalidModelCopy
}

nonisolated
class StoreMigrationManager {
    
    static func model(version: Int, bundle: Bundle) throws -> NSManagedObjectModel {
        let name = "Backend \(version)"
        guard let directory = bundle.url(forResource: "D2AModel", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: directory.appendingPathComponent(name + ".mom")) else {
            throw MigrationError.missingModel(name)
        }
        return model
    }
    
    private let migrations: [any StoreMigrating]
    private let currentModelVersion: Int
    private let fileManager: FileManager
    private let storeURL: URL
    private let modelLoader: (Int) throws -> NSManagedObjectModel
    private let logger: D2ALogger
    
    init(
        storeURL: URL,
        migrationSteps: [any StoreMigrating]? = nil,
        fileManager: FileManager = .default,
        bundle: Bundle = .main,
        logger: D2ALogger = .shared,
        currentModelVersion: Int = 3,
        modelLoader: ((Int) throws -> NSManagedObjectModel)? = nil
    ) {
        let loader = modelLoader ?? { try Self.model(version: $0, bundle: bundle) }
        self.storeURL = storeURL
        self.migrations = migrationSteps ?? [StoreMigrationV3(modelLoader: loader, logger: logger)]
        self.fileManager = fileManager
        self.modelLoader = loader
        self.currentModelVersion = currentModelVersion
        self.logger = logger
    }

    /// Resolves the entire path before modifying a store. This can be tested with metadata alone.
    func migrationSteps(for metadata: [String: Any]) throws -> [any StoreMigrating] {
        let currentModel = try modelLoader(currentModelVersion)
        if currentModel.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata) {
            return []
        }

        let sorted = migrations.sorted { $0.sourceVersion < $1.sourceVersion }
        var candidateMetadata = metadata
        var result: [any StoreMigrating] = []
        for step in sorted {
            let source = try step.sourceModel
            guard source.isConfiguration(withName: nil, compatibleWithStoreMetadata: candidateMetadata) else {
                continue
            }
            let destination = try step.destinationModel
            result.append(step)
            candidateMetadata = [NSStoreModelVersionHashesKey: destination.entityVersionHashesByName]
            if currentModel.isConfiguration(withName: nil, compatibleWithStoreMetadata: candidateMetadata) {
                return result
            }
        }
        throw MigrationError.unsupportedStoreVersion
    }

    func migrateIfNeeded() throws {
        logger.debug("Start CoreData migrating...", category: .coreData)
        guard fileManager.fileExists(atPath: storeURL.path) else {
            logger.notice("CoreData store doesn't exist at \(storeURL.path). Create a new file...", category: .coreData)
            return
        }
        
        let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(
            ofType: NSSQLiteStoreType, at: storeURL, options: [NSReadOnlyPersistentStoreOption: true]
        )
        
        for step in try migrationSteps(for: metadata) {
            try migrateStore(step: step)
        }
    }
    
    private func migrateStore(step: any StoreMigrating) throws {
        let temporaryDirectory = try createMigrationDirectory()
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
    
    private func createMigrationDirectory() throws -> URL {
        logger.debug("Copying current store for migration...", category: .coreData)
        let temporaryDirectory = storeURL.deletingLastPathComponent()
            .appendingPathComponent("Migration-" + UUID().uuidString, isDirectory: true)
        try fileManager.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true)
        return temporaryDirectory
    }
}
