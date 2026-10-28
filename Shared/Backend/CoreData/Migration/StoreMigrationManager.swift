import CoreData

protocol StoreMigrating {
    
    var destinationVersion: Int { get }

    func migrate(from sourceURL: URL, to destinationURL: URL) throws
    
    func needMigration(metadata: [String: Any]) -> Bool
}

extension StoreMigrating {
    
    var sourceVersion: Int {
        return destinationVersion - 1
    }
    
    func model(for version: Int, bundle: Bundle) throws -> NSManagedObjectModel {
        let name = "Backend \(version)"
        guard let directory = bundle.url(forResource: "D2AModel", withExtension: "momd"),
              let model = NSManagedObjectModel(contentsOf: directory.appendingPathComponent(name + ".mom")) else {
            throw MigrationError.missingModel(name)
        }
        return model
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
    
    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }
    
    func migrateIfNeeded(at storeURL: URL, bundle: Bundle = .main) throws {
        guard FileManager.default.fileExists(atPath: storeURL.path) else { return }
        let destinationModel = try Self.model(version: currentModel, bundle: bundle)
        let metadata = try NSPersistentStoreCoordinator.metadataForPersistentStore(
            ofType: NSSQLiteStoreType, at: storeURL, options: [NSReadOnlyPersistentStoreOption: true]
        )
        guard !destinationModel.isConfiguration(withName: nil, compatibleWithStoreMetadata: metadata) else {
            return
        }
        
        var migrationSteps: [any StoreMigrating] = []
        
        for migration in migrations {
            if migration.needMigration(metadata: metadata) {
                migrationSteps.insert(migration, at: 0)
            } else {
                break
            }
        }
        
        for step in migrationSteps {
            let temporaryDirectory = storeURL.deletingLastPathComponent()
                .appendingPathComponent("Migration-" + UUID().uuidString, isDirectory: true)
            try FileManager.default.createDirectory(at: temporaryDirectory, withIntermediateDirectories: true)
            defer { try? fileManager.removeItem(at: temporaryDirectory) }
            let destinationURL = temporaryDirectory.appendingPathComponent("D2AModel.sqlite")
            
            try step.migrate(from: storeURL, to: destinationURL)
            
            // Core Data replaces the SQLite store and its sidecars together.
            let coordinator = NSPersistentStoreCoordinator(managedObjectModel: destinationModel)
            try coordinator.replacePersistentStore(
                at: storeURL, destinationOptions: nil,
                withPersistentStoreFrom: destinationURL, sourceOptions: nil, ofType: NSSQLiteStoreType
            )
        }
    }
}
