//
//  PersistanceContainer.swift
//  D2A
//
//  Created by Shibo Tong on 28/9/2022.
//

import CoreData
import Combine

protocol PersistanceProviding {
    
    var container: NSPersistentContainer { get }
    
    func makeContext(author: String?) -> NSManagedObjectContext

    func saveODData(data: [PersistanceModel], type: NSManagedObject.Type) async
    
    func fetchGameMode(id: Int) -> GameMode?
    
    func calculateDaysSinceLastMatch(userID: String, context: NSManagedObjectContext) -> Double?
}

enum PersistanceError: Error {
    case insertError
    case persistentHistoryChangeError
}

class PersistanceProvider: PersistanceProviding {

    static let shared = PersistanceProvider()

    private var remoteChangeCancellable: AnyCancellable?
    private var backgroundChangeCancellable: AnyCancellable?
    let container: NSPersistentContainer

    /// A peristent history token used for fetching transactions from the store.
    private var lastToken: NSPersistentHistoryToken?

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
        
        // Observe Core Data remote change notifications on the queue where the changes were made.
        remoteChangeCancellable = NotificationCenter.Publisher(center: .default, name: .NSPersistentStoreRemoteChange)
            .sink(receiveValue: { [weak self] note in
                Task {
                    await self?.fetchPersistentHistory()
                }
            })
        
        loadContainer(inMemory: inMemory)
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

    func makeContext(author: String? = nil) -> NSManagedObjectContext {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = container.viewContext
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
        let context = mainContext ? container.viewContext : makeContext(author: "ODData")
        if mainContext {
            updateData(data: data, context: context)
            return
        }
        
        if hasData(for: type, context: context) {
            updateData(data: data, context: context)
        } else {
            batchInsertData(data, into: type.entity(), context: context)
        }
    }
    
    // MARK: - Save Specific data
    private func updateData(data: [PersistanceModel], context: NSManagedObjectContext) {
        for object in data {
            context.performAndWait {
                do {
                    let newObject = try object.update(context: context)
                    guard newObject.hasChanges else {
                        return
                    }
                    try context.save()
                } catch {
                    logError("An error occured when updating data in Core Data \(error.localizedDescription)", category: .coredata)
                }
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
