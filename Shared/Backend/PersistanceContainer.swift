//
//  PersistanceContainer.swift
//  D2A
//
//  Created by Shibo Tong on 28/9/2022.
//

import CoreData

enum PersistanceError: Error {
    case insertError
    case persistentHistoryChangeError
}

class PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let previewID = "preview"
        UserProfile.create(id: previewID, favourite: true, register: true, controller: result)
        _ = RecentMatch.create(userID: previewID, matchID: previewID, controller: result)
        return result
    }()

    let container: NSPersistentContainer
    private var notificationToken: NSObjectProtocol?
    
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

    init(inMemory: Bool = false) {
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME)!
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
        container = NSPersistentContainer(name: "D2AModel")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            container.persistentStoreDescriptions = [description]
        }
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
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
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        loadHistoryToken()
        // Observe Core Data remote change notifications on the queue where the changes were made.
        notificationToken = NotificationCenter.default.addObserver(forName: .NSPersistentStoreRemoteChange, object: nil, queue: nil) { [weak self] note in
            Task {
                guard let self = self else { return }
                await self.fetchPersistentHistory()
            }
        }
    }
    
    func fetchPersistentHistory() async {
        do {
            try await fetchPersistentHistoryTransactionsAndChanges()
        } catch {
           print("\(error.localizedDescription)")
        }
    }

    private func fetchPersistentHistoryTransactionsAndChanges() async throws {
        let taskContext = makeContext()
        taskContext.name = "persistentHistoryContext"
        print("Start fetching persistent history changes from the store...")

        try await taskContext.perform { [weak self] in
            // Execute the persistent history change since the last transaction.
            /// - Tag: fetchHistory
            let changeRequest = NSPersistentHistoryChangeRequest.fetchHistory(after: self?.lastToken)
            let historyResult = try taskContext.execute(changeRequest) as? NSPersistentHistoryResult
            if let history = historyResult?.result as? [NSPersistentHistoryTransaction],
               !history.isEmpty {
                print(history)
                self?.mergePersistentHistoryChanges(from: history)
                return
            }
            
            print("No persistent history transactions found.")
            throw PersistanceError.persistentHistoryChangeError
        }
    }

    private func mergePersistentHistoryChanges(from history: [NSPersistentHistoryTransaction]) {
        print("Received \(history.count) persistent history transactions.")
        // Update view context with objectIDs from history change request.
        /// - Tag: mergeChanges
        let viewContext = container.viewContext
        viewContext.perform { [weak self] in
            for transaction in history {
                viewContext.mergeChanges(fromContextDidSave: transaction.objectIDNotification())
                self?.storeHistoryToken(transaction.token)
            }
        }
    }
    
    /// Save latest history token to disk
    private func storeHistoryToken(_ token: NSPersistentHistoryToken) {
        do {
            let data = try NSKeyedArchiver
                .archivedData(withRootObject: token, requiringSecureCoding: true)
            try data.write(to: tokenFileURL)
            lastToken = token
        } catch {
            // log any errors
        }
    }
    
    /// Load saved history token to decide which part of CoreDate remote change should be fetched
    private func loadHistoryToken() {
        do {
            let tokenData = try Data(contentsOf: tokenFileURL)
            lastToken = try NSKeyedUnarchiver
                .unarchivedObject(ofClass: NSPersistentHistoryToken.self, from: tokenData)
        } catch {
            print("History Token not exist")
            // log any errors
        }
    }
    
    func makeContext(author: String? = nil) -> NSManagedObjectContext {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = container.viewContext
        privateContext.transactionAuthor = author
        return privateContext
    }
    
    func fetchFavouriteUserProfiles() -> [UserProfile] {
        let fetchRequest = UserProfile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "favourite = %d", true)
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
}
