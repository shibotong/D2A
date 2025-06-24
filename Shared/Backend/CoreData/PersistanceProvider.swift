//
//  PersistanceContainer.swift
//  D2A
//
//  Created by Shibo Tong on 28/9/2022.
//

import CoreData

protocol PersistanceProviding {
    func saveAbilitiesToHero(heroAbilities: [String: ODHeroAbilities]) async

    func saveODData(data: [PersistanceModel], type: NSManagedObject.Type) async
    
    func fetchGameMode(id: Int) -> GameMode?
}

enum PersistanceError: Error {
    case insertError
    case persistentHistoryChangeError
}

class PersistanceProvider: PersistanceProviding {

    static let shared = PersistanceProvider()

    static let preview = PersistanceProvider()

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
        Self.registerClasses()
        container = NSPersistentContainer(name: "D2AModel")
        container.viewContext.automaticallyMergesChangesFromParent = true
        loadContainer(inMemory: inMemory)
    }

    static func registerClasses() {
        // Register the transformer with the exact name used in the Core Data model
        ArrayValueTransformer<AbilityAttribute>.registerTransformer(with: .abilityAttribute)
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

    // MARK: - Save constant data
    func saveODData<T: NSManagedObject>(data: [PersistanceModel], type: T.Type) async {
        let context = container.newBackgroundContext()
        if await hasData(for: type, context: context) {
            await updateData(data: data, context: context)
        } else {
            await batchInsertData(data, into: type.entity(), context: context)
        }
    }
    
    // MARK: - Save Specific data

    func saveAbilitiesToHero(heroAbilities: [String: ODHeroAbilities]) async {
        let context = container.newBackgroundContext()
        await context.perform {
            for (name, heroAbility) in heroAbilities {
                guard let hero = Hero.fetchByName(name: name, context: context) else {
                    logError("Cannot find hero: \(name)", category: .coredata)
                    continue
                }
                let abilityNames = heroAbility.abilities
                
                if let currentAbilities = hero.abilities?.compactMap({ ($0 as? Ability) }) {
                    guard currentAbilities.compactMap(\.name) != abilityNames else {
                        continue
                    }
                    for ability in currentAbilities {
                        hero.removeFromAbilities(ability)
                    }
                }
                
                let abilities = Ability.fetchByNames(names: abilityNames, context: context)
                
                for ability in abilities {
                    hero.addToAbilities(ability)
                }
                if hero.hasChanges {
                    do {
                        try context.save()
                        logDebug("Save hero ability \(hero.id) success", category: .coredata)
                    } catch {
                        logError("\(hero.id) abilities save failed. \(error)", category: .coredata)
                    }
                }
            }
        }
    }

    private func updateData(data: [PersistanceModel], context: NSManagedObjectContext) async {
        for object in data {
            await context.perform {
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
    private func hasData<T: NSManagedObject>(for entity: T.Type, context: NSManagedObjectContext) async -> Bool {
        let request = entity.fetchRequest()
        request.fetchLimit = 1
        return await context.perform {
            do {
                let count = try context.count(for: request)
                return count > 0
            } catch {
                logError("Cannot count number of \(entity) saved in Core Data", category: .coredata)
                return true
            }
        }
    }

    private func batchInsertData(_ data: [PersistanceModel], into entity: NSEntityDescription, context: NSManagedObjectContext) async {
        let insertRequest = NSBatchInsertRequest(entity: entity, objects: data.map { $0.dictionaries })
        insertRequest.resultType = .statusOnly
        await context.perform {
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
