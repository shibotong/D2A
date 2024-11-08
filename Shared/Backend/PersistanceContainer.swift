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
        UserProfile.create(id: "preview 1", favourite: true, controller: result)
        UserProfile.create(id: "preview 2", favourite: true, controller: result)
        UserProfile.create(id: "preview 3", favourite: true, controller: result)
        UserProfile.create(id: "preview 4", favourite: true, controller: result)
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

    init(inMemory: Bool = uiTesting ? true : false) {
        container = NSPersistentContainer(name: "D2AModel")
        container.viewContext.automaticallyMergesChangesFromParent = true
        loadContainer(inMemory: inMemory)
    }
    
    private func removeContainer() {
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME)!
        let storeURL = containerURL.appendingPathComponent("D2AModel.sqlite")
        do {
            try FileManager.default.removeItem(at: storeURL)
            loadContainer()
        } catch {
            DotaEnvironment.shared.error = true
            DotaEnvironment.shared.errorMessage = "There are some problems with the App. Please delete and reinstall."
        }
    }
    
    private func loadContainer(inMemory: Bool = false) {
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME)!
        let storeURL = containerURL.appendingPathComponent("D2AModel.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        
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
    
    func makeContext(author: String? = nil) -> NSManagedObjectContext {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = container.viewContext
        privateContext.transactionAuthor = author
        privateContext.automaticallyMergesChangesFromParent = true
        return privateContext
    }
    
    func fetchFirstWidgetUser() -> UserProfile? {
        let fetchRequest = UserProfile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "favourite = %d", true)
        do {
            let result = try container.viewContext.fetch(fetchRequest)
            return result.first(where: { $0.register }) ?? result.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
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
                  let deleteResult = batchDelete.result as? [NSManagedObjectID] else {
                print("batch delete error")
                return
            }
            
            let deletedObjects: [AnyHashable: Any] = [NSDeletedObjectsKey: deleteResult]
            
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: deletedObjects, into: [strongSelf.container.viewContext])
        }
    }
    
    func batchInsert<T: NSManagedObject>(entity: T, objectHandler: @escaping (NSManagedObject) -> Bool) throws {
        /// Create Batch Insert Request
        let insertRequest = NSBatchInsertRequest(entity: T.entity(), managedObjectHandler: objectHandler)
        
        let privateContext = container.newBackgroundContext()

        /// Set the Result Type, in our case we need object IDs
        insertRequest.resultType = .statusOnly
        /// Execute the request using the background context already created.
        let result = try privateContext.execute(insertRequest) as! NSBatchInsertResult
        /// Finally we merge using the objectIDs we got from the results.
        if let objectIDs = result.result as? [NSManagedObjectID], !objectIDs.isEmpty {
            let save = [NSInsertedObjectsKey: objectIDs]
            
//            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: save, into: [mainContext])
        }
    }
}
