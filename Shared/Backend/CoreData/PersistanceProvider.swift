//
//  PersistanceContainer.swift
//  D2A
//
//  Created by Shibo Tong on 28/9/2022.
//

import CoreData
import Combine

protocol PersistanceProviding {
    
    var mainContext: D2AManagedObjectContext { get }
    
    var container: NSPersistentContainer { get }
    
    func makeContext(author: String?) -> D2AManagedObjectContext

    func saveODData(data: [PersistanceModel], type: NSManagedObject.Type) async
    
    func fetchGameMode(id: Int) -> GameMode?
    
    func calculateDaysSinceLastMatch(userID: String, context: NSManagedObjectContext) -> Double?
    
    func loadDefaultData() throws
}

enum PersistanceError: Error {
    case insertError
    case persistentHistoryChangeError
}

class PersistanceProvider: PersistanceProviding {

    static let shared = PersistanceProvider()

    let container: NSPersistentContainer
    let mainContext: D2AManagedObjectContext

    /// A peristent history token used for fetching transactions from the store.
    private var lastToken: NSPersistentHistoryToken?
    
    private var remoteChangeCancellable: AnyCancellable?
    private var backgroundChangeCancellable: AnyCancellable?

    /// URL of tokenFile
    private lazy var tokenFileURL: URL = {
        let url = NSPersistentContainer.defaultDirectoryURL()
            .appendingPathComponent("D2AToken", isDirectory: true)
        do {
            try FileManager.default
                .createDirectory(
                    at: url,
                    withIntermediateDirectories: true,
                    attributes: nil)
        } catch {
            // log any errors
        }
        return url.appendingPathComponent("token.data", isDirectory: false)
    }()

    init(inMemory: Bool = uiTesting ? true : false) {
        Self.registerClasses()
        container = NSPersistentContainer(name: "D2AModel")
        container.viewContext.automaticallyMergesChangesFromParent = true
        mainContext = D2AManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = container.persistentStoreCoordinator
        
        

        // Observe Core Data remote change notifications on the queue where the changes were made.
        remoteChangeCancellable = NotificationCenter.Publisher(center: .default, name: .NSPersistentStoreRemoteChange)
            .sink(receiveValue: { [weak self] note in
                Task {
                    await self?.fetchPersistentHistory()
                }
            })
        
        // Core Data
        loadContainer(inMemory: inMemory)
    }
    
    func loadDefaultData() throws {
        if let hero = try mainContext.fetchOne(type: Hero.self) {
            logInfo("Constant data exists", category: .coredata)
            return
        }
        logDebug("Constant data doesn't exist, adding default data", category: .coredata)
        let processor = OpenDotaConstantProcessor.shared
        // Heroes
        let defaultHeroes = try FileReader.loadFile(filename: OpenDotaConstantService.heroes.rawValue, as: [String: ODHero].self)
        let defaultAbilities = try FileReader.loadFile(filename: OpenDotaConstantService.abilities.rawValue, as: [String: ODHeroAbilities].self)
        let defaultLores = try FileReader.loadFile(filename: OpenDotaConstantService.heroLore.rawValue, as: [String: String].self)
        let heroes = processor.processHeroes(heroes: defaultHeroes, abilities: defaultAbilities, lores: defaultLores)
        saveODData(data: heroes, type: Hero.self)
        
        // Abilities
        let abilityDict = try FileReader.loadFile(filename: OpenDotaConstantService.abilities.rawValue, as: [String: ODAbility].self)
        let abilityIDs = try FileReader.loadFile(filename: OpenDotaConstantService.abilityIDs.rawValue, as: [String: String].self)
        let scepters = try FileReader.loadFile(filename: OpenDotaConstantService.aghs.rawValue, as: [ODScepter].self)
        let abilities = processor.processAbilities(ability: abilityDict, ids: abilityIDs, scepters: scepters)
        saveODData(data: abilities, type: Ability.self)
        
        // GameModes
        let gameModesDict = try FileReader.loadFile(filename: OpenDotaConstantService.gameMode.rawValue, as: [String: ODGameMode].self)
        let gameModes = processor.processGameModes(modes: gameModesDict)
        saveODData(data: gameModes, type: GameMode.self)
    }

    static func registerClasses() {
        // Register the transformer with the exact name used in the Core Data model
        ArrayValueTransformer<AbilityAttribute>.registerTransformer(with: .abilityAttribute)
        ArrayValueTransformer<Role>.registerTransformer(with: .heroRole)
        ArrayValueTransformer<Talent>.registerTransformer(with: .heroTalent)
        ArrayValueTransformer<HeroTranslation>.registerTransformer(with: .heroTranslation)
    }

    private func removeContainer() {
        let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: GROUP_NAME)!
        let storeURL = containerURL.appendingPathComponent("D2AModel.sqlite")
        do {
            try FileManager.default.removeItem(at: storeURL)
            loadContainer()
        } catch {
            EnvironmentController.shared.error = true
            EnvironmentController.shared.errorMessage =
                "There are some problems with the App. Please delete and reinstall."
        }
    }

    private func loadContainer(inMemory: Bool = false) {
        let containerURL = FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: GROUP_NAME)!
        let storeURL = containerURL.appendingPathComponent("D2AModel.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)

        // Enable persistent store remote change notifications
        /// - Tag: persistentStoreRemoteChange
        description.setOption(true as NSNumber,
                              forKey: NSPersistentStoreRemoteChangeNotificationPostOptionKey)

        // Enable persistent history tracking
        /// - Tag: persistentHistoryTracking
        description.setOption(true as NSNumber,
                              forKey: NSPersistentHistoryTrackingKey)
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            container.persistentStoreDescriptions = [description]
        }
        
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSMigratePersistentStoresAutomaticallyOption)
        container.persistentStoreDescriptions.first?.setOption(true as NSNumber, forKey: NSInferMappingModelAutomaticallyOption)

        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.

                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("An error occured with persistence store \(error.localizedDescription)")
            }
        })
    }
    
    private func fetchPersistentHistory() async {
        do {
            try await fetchPersistentHistoryTransactionsAndChanges()
        } catch {
            logDebug("\(error.localizedDescription)", category: .coredata)
        }
    }

    private func fetchPersistentHistoryTransactionsAndChanges() async throws {
        let taskContext = makeContext(author: "persistentHistoryContext")
        logDebug("Start fetching persistent history changes from the store...", category: .coredata)

        try await taskContext.perform {
            // Execute the persistent history change since the last transaction.
            /// - Tag: fetchHistory
            let changeRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: self.lastToken)
            let historyResult = try taskContext.execute(changeRequest) as? NSPersistentHistoryResult
            if let history = historyResult?.result as? [NSPersistentHistoryTransaction],
               !history.isEmpty {
                self.mergePersistentHistoryChanges(from: history)
                return
            }

            logDebug("No persistent history transactions found.", category: .coredata)
            throw D2AError(message: "Save failed: No persistent history transactions found.")
        }

        logDebug("Finished merging history changes.", category: .coredata)
    }
    
    private func mergePersistentHistoryChanges(from history: [NSPersistentHistoryTransaction]) {
        logDebug("Received \(history.count) persistent history transactions.", category: .coredata)
        // Update view context with objectIDs from history change request.
        /// - Tag: mergeChanges
        let viewContext = container.viewContext
        viewContext.perform {
            for transaction in history {
                viewContext.mergeChanges(fromContextDidSave: transaction.objectIDNotification())
                self.lastToken = transaction.token
            }
        }
    }

    func makeContext(author: String? = nil) -> D2AManagedObjectContext {
        let privateContext = D2AManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = mainContext
        privateContext.transactionAuthor = author
        privateContext.automaticallyMergesChangesFromParent = true
        return privateContext
    }

    func deleteRecentMatchesForUserID(userID: String) {
        let viewContext = makeContext(author: userID)
        weak var weakContext = viewContext
        viewContext.perform { [weak self] in
            print("start removing recent matches for player \(userID)")
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = RecentMatch.fetchRequest()
            let predicate = NSPredicate(format: "playerId = %@", userID)
            fetchRequest.predicate = predicate

            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            deleteRequest.resultType = .resultTypeObjectIDs

            guard let strongSelf = self,
                let batchDelete = try? weakContext?.execute(deleteRequest) as? NSBatchDeleteResult,
                let deleteResult = batchDelete.result as? [NSManagedObjectID]
            else {
                print("batch delete error")
                return
            }

            let deletedObjects: [AnyHashable: Any] = [NSDeletedObjectsKey: deleteResult]

            NSManagedObjectContext.mergeChanges(
                fromRemoteContextSave: deletedObjects, into: [strongSelf.container.viewContext])
        }
    }
    
    // MARK: - Fetch data

    func fetchGameMode(id: Int) -> GameMode? {
        do {
            guard let mode = try GameMode.fetch(id: id, context: container.viewContext) else {
                logError("Failed to fetch game mode ID: \(id), no data found", category: .constants)
                return nil
            }
            return mode
        } catch {
            logError("Failed to fetch game mode: \(error.localizedDescription)", category: .coredata)
            return nil
        }
    }
    
    func calculateDaysSinceLastMatch(userID: String, context: NSManagedObjectContext) -> Double? {
        guard let latestMatch = RecentMatch.fetch(userID: userID, count: 1, viewContext: context).first else {
            return nil
        }
        
        var days: Double?
        // here should be timeIntervalSinceNow
        if let lastMatchStartTime = latestMatch.startTime?.timeIntervalSinceNow {
            let oneDay: Double = 60 * 60 * 24

            // Decrease 1 sec to avoid adding repeated match
            days = -(lastMatchStartTime + 1) / oneDay
        }
        
        return days
    }

    // MARK: - Save constant data
    func saveODData<T: NSManagedObject>(data: [PersistanceModel], type: T.Type) {
        saveODData(data: data, type: type, mainContext: false)
    }
    
    func saveODData<T: NSManagedObject>(data: [PersistanceModel], type: T.Type, mainContext: Bool) {
        let useMainContext = data.count <= 5 || mainContext
        let context = useMainContext ? self.mainContext : makeContext(author: "ODData")
        
        if useMainContext || hasData(for: type, context: context) {
            updateData(data: data, context: context)
        } else {
            batchInsertData(data, into: type.entity(), context: context)
        }
    }
    
    // MARK: - Save Specific data
    private func updateData(data: [PersistanceModel], context: NSManagedObjectContext) {
        context.performAndWait {
            for object in data {
                do {
                    _ = try object.update(context: context)
                } catch {
                    logError("An error occured when updating data in Core Data \(error.localizedDescription)", category: .coredata)
                }
            }
            do {
                try context.save()
            } catch {
                logError("An error occured when save data in Core Data \(error.localizedDescription)", category: .coredata)
            }
        }
    }

    /// Check if there is any data saved in core data
    private func hasData<T: NSManagedObject>(for entity: T.Type, context: NSManagedObjectContext) -> Bool {
        let request = entity.fetchRequest()
        request.fetchLimit = 1
        return context.performAndWait {
            do {
                let count = try context.count(for: request)
                return count > 0
            } catch {
                logError("Cannot count number of \(entity) saved in Core Data", category: .coredata)
                return true
            }
        }
    }

    private func batchInsertData(_ data: [PersistanceModel], into entity: NSEntityDescription, context: NSManagedObjectContext) {
        let insertRequest = NSBatchInsertRequest(entity: entity, objects: data.map { $0.dictionaries })
        insertRequest.resultType = .statusOnly
        context.performAndWait {
            do {
                let fetchResult = try context.execute(insertRequest)
                if let batchInsertResult = fetchResult as? NSBatchInsertResult,
                   let success = batchInsertResult.result as? Bool {
                    if !success {
                        logError("Failed to insert data in \(entity.name ?? "Unknown entity")", category: .coredata)
                    } else {
                        logDebug("Insert data in \(entity.name ?? "Unknown entity") success", category: .coredata)
                    }
                } else {
                    logWarn("Cast NSBatchInsertResult failed", category: .coredata)
                }
            } catch {
                logError("An error occured in batch insert \(entity.name ?? "Unknown entity") \(error)", category: .coredata)
            }
        }
    }
}
