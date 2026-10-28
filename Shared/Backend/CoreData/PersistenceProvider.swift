//
//  PersistanceContainer.swift
//  D2A
//
//  Created by Shibo Tong on 28/9/2022.
//

import CoreData

enum PersistenceError: Error {
    case insertError
    case persistentHistoryChangeError
    case heroNotFound(Int)
    case abilityNotFound(Int)
}

protocol CoreDataContextProviding {
    @MainActor
    var mainContext: NSManagedObjectContext { get }
    
    nonisolated
    func backgroundContext(name: String?) -> NSManagedObjectContext
}

extension CoreDataContextProviding {
    
    nonisolated
    func backgroundContext() -> NSManagedObjectContext {
        return backgroundContext(name: nil)
    }
}

nonisolated
final class PersistenceProvider: CoreDataContextProviding, Sendable {
    
    static let shared = PersistenceProvider()

    @MainActor
    static var preview: PersistenceProvider = {
        let result = PersistenceProvider(inMemory: true)
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
    
    @MainActor
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

    init(inMemory: Bool = isRunningTests ? true : false) {
        container = NSPersistentContainer(name: "D2AModel")
        container.viewContext.automaticallyMergesChangesFromParent = true
        loadContainer(inMemory: inMemory)
    }
    
    private func loadContainer(inMemory: Bool = false) {
        let containerURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: GROUP_NAME)!
        let storeURL = containerURL.appendingPathComponent("D2AModel.sqlite")
        let description = NSPersistentStoreDescription(url: storeURL)
        
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        } else {
            do {
                try StoreMigrationManager().migrateIfNeeded(at: storeURL)
            } catch {
                fatalError("Core Data migration failed; the existing store was retained: \(error)")
            }
            description.shouldMigrateStoreAutomatically = false
            description.shouldInferMappingModelAutomatically = false
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
    
    @available(*, deprecated, renamed: "backgroundContext", message: "Use protocol function instead")
    func makeContext(author: String? = nil) -> NSManagedObjectContext {
        return backgroundContext(name: author)
    }
    
    func backgroundContext(name: String?) -> NSManagedObjectContext {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = container.viewContext
        privateContext.transactionAuthor = name
        privateContext.automaticallyMergesChangesFromParent = true
        return privateContext
    }
    
    func fetchFirstWidgetUser(context: NSManagedObjectContext) -> UserProfile? {
        let fetchRequest = UserProfile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "favourite = %d", true)
        do {
            let result = try context.fetch(fetchRequest)
            return result.first(where: { $0.register }) ?? result.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func deleteRecentMatchesForUserID(userID: String) {
        let viewContext = makeContext(author: userID)
        weak let weakContext = viewContext
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
}
