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
}

protocol PersistenceProviding {
    var mainContext: NSManagedObjectContext { get }
    @available(*, deprecated, renamed: "fetch")
    func fetchHero(id: Double, context: NSManagedObjectContext) throws -> Hero?
    
    func fetch(heroID: Int, context: NSManagedObjectContext) throws -> Hero?
    func saveHero(id: Int, data: [String: Any], in context: NSManagedObjectContext, logger: DataSyncingLogger?) throws
    func fetchHeroLocalization(id: Int, language: DataLanguageEnum, context: NSManagedObjectContext) throws -> HeroTranslation?
    func saveHeroLocalization(localization: SKHero, language: DataLanguageEnum, in context: NSManagedObjectContext) throws
}

class PersistenceProvider: PersistenceProviding {
    static let shared = PersistenceProvider()

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
    
    var mainContext: NSManagedObjectContext {
        return container.viewContext
    }

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
    
    
    func fetchHero(id: Double, context: NSManagedObjectContext) throws -> Hero? {
        return try fetch(heroID: Int(id), context: context)
    }
    
    func fetch(heroID: Int, context: NSManagedObjectContext) throws -> Hero? {
        let fetchHero = Hero.fetchRequest()
        fetchHero.predicate = NSPredicate(format: "id == %f", Double(heroID))
        
        let results = try context.fetch(fetchHero)
        return results.first
    }
    
    func saveHero(id: Int, data: [String: Any], in context: NSManagedObjectContext, logger: DataSyncingLogger?) throws {
        let hero = try fetch(heroID: id, context: context) ?? Hero(context: context)
        
        var closure: ((String) -> ())?
        if let logger {
            closure = { key in
                Task {
                    await logger.addError(type: .hero, error: .dataType, key: key)
                }
            }
        }
        
        setIfNotEqual(entity: hero, path: \.id, value: Double(id))
        setIfExist(entity: hero, path: \.name, data: data, key: "name", errorCompletion: closure)
        setIfExist(entity: hero, path: \.primaryAttr, data: data, key: "primary_attr", errorCompletion: closure)
        setIfExist(entity: hero, path: \.baseHealth, data: data, key: "base_health", errorCompletion: closure)
        setIfExist(entity: hero, path: \.baseHealthRegen, data: data, key: "base_health_regen", errorCompletion: closure)
        setIfExist(entity: hero, path: \.baseMana, data: data, key: "base_mana", errorCompletion: closure)
        setIfExist(entity: hero, path: \.baseManaRegen, data: data, key: "base_mana_regen", errorCompletion: closure)
        setIfExist(entity: hero, path: \.baseArmor, data: data, key: "base_armor", errorCompletion: closure)
        setIfExist(entity: hero, path: \.baseMr, data: data, key: "base_mr", errorCompletion: closure)
        setIfExist(entity: hero, path: \.baseAttackMin, data: data, key: "base_attack_min", errorCompletion: closure)
        setIfExist(entity: hero, path: \.baseAttackMax, data: data, key: "base_attack_max", errorCompletion: closure)
        setIfExist(entity: hero, path: \.baseStr, data: data, key: "base_str", errorCompletion: closure)
        setIfExist(entity: hero, path: \.baseAgi, data: data, key: "base_agi", errorCompletion: closure)
        setIfExist(entity: hero, path: \.baseInt, data: data, key: "base_int", errorCompletion: closure)
        setIfExist(entity: hero, path: \.gainStr, data: data, key: "str_gain", errorCompletion: closure)
        setIfExist(entity: hero, path: \.gainAgi, data: data, key: "agi_gain", errorCompletion: closure)
        setIfExist(entity: hero, path: \.gainInt, data: data, key: "int_gain", errorCompletion: closure)
        setIfExist(entity: hero, path: \.attackRange, data: data, key: "attack_range", errorCompletion: closure)
        setIfExist(entity: hero, path: \.projectileSpeed, data: data, key: "projectile_speed")
        setIfExist(entity: hero, path: \.attackRate, data: data, key: "attack_rate", errorCompletion: closure)
        setIfExist(entity: hero, path: \.moveSpeed, data: data, key: "move_speed", errorCompletion: closure)
        setIfExist(entity: hero, path: \.turnRate, data: data, key: "turn_rate", defaultValue: 0.6, errorCompletion: closure)
        setIfExist(entity: hero, path: \.visionDaytimeRange, data: data, key: "day_vision", errorCompletion: closure)
        setIfExist(entity: hero, path: \.visionNighttimeRange, data: data, key: "night_vision", errorCompletion: closure)
    }
    
    func fetchHeroLocalization(id: Int, language: DataLanguageEnum, context: NSManagedObjectContext) throws -> HeroTranslation? {
        let fetchRequest = HeroTranslation.fetchRequest()
        let predicate = NSPredicate(format: "heroID = %d AND language = %@", id, language.rawValue)
        fetchRequest.predicate = predicate

        let results = try context.fetch(fetchRequest)
        return results.first
    }
    
    func saveHeroLocalization(localization: SKHero, language: DataLanguageEnum, in context: NSManagedObjectContext) throws {
        let translation = try fetchHeroLocalization(id: localization.id, language: language, context: context) ?? HeroTranslation(context: context)
        setIfNotEqual(entity: translation, path: \.language, value: language.rawValue)
        setIfNotEqual(entity: translation, path: \.heroID, value: Int16(localization.id))
        setIfNotEqual(entity: translation, path: \.displayName, value: localization.displayName)
        setIfNotEqual(entity: translation, path: \.lore, value: localization.lore)
        setIfNotEqual(entity: translation, path: \.hype, value: localization.hype)
    }
}
