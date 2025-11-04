//
//  ConstantsController.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import CoreData
import Foundation
import StratzAPI
import SwiftUI

/// `ConstantsController` is responsible for saving hero and ability data into device (This process is only occured on iOS)
class ConstantsController: ObservableObject {
    
    @Published var isLoading = false
    @Published var allHeroes: [Hero] = []
    
    private var heroes = [String: ODHero]()
    private var lobbyTypes = [String: LobbyType]()
    private var regions = [String: String]()
    private var items = [String: Item]()
    private var itemIDTable = [String: String]()
    private var abilityIDTable = [String: String]()
    private var abilities = [String: ODAbility]()
    private var heroAbilities = [String: ODHeroAbilities]()
    private var apolloAbilities = [StratzAbility]()
    
    static var shared = ConstantsController()
    
    let url = "https://api.opendota.com/api/herostats"
    
    private let stratzProvider: StratzProviding
    private let openDotaProvider: OpenDotaConstantProviding
    private let persistanceProvider: PersistanceProviding
    
    init(
        stratzProvider: StratzProviding = StratzController.shared,
        openDotaProvider: OpenDotaConstantProviding = OpenDotaConstantProvider.shared,
        persistanceProvider: PersistanceProviding = PersistanceProvider.shared
    ) {
        self.stratzProvider = stratzProvider
        self.openDotaProvider = openDotaProvider
        self.persistanceProvider = persistanceProvider
        fetchHeroes()
    }
    
    private func fetchHeroes() {
        let context = persistanceProvider.mainContext
        do {
            let heroes = try context.fetchAll(type: Hero.self)
            self.allHeroes = heroes
        } catch {
            logError("Not able to fetch all heroes. \(error.localizedDescription)", category: .constants)
        }
    }
    
    func loadData() async {
        if isTesting {
            logDebug("is Running Unit Test, not fetching from API", category: .constants)
            return
        }
        regions = loadRegion()!
        lobbyTypes = loadLobby()!
        
        async let idTable = loadItemIDs()
        async let items = loadItems()
        async let heroes = loadHeroes()
        async let abilityIDTable = loadAbilityID()
        async let abilities = loadAbilities()
        async let heroAbilities = loadHeroAbilities()
        async let stratzAbilities = stratzProvider.loadAbilities()
        
        self.itemIDTable = await idTable
        self.items = await items
        self.heroes = await heroes
        self.abilityIDTable = await abilityIDTable
        self.abilities = await abilities
        self.heroAbilities = await heroAbilities
        self.apolloAbilities = await stratzAbilities
        
        await loadConstantData()
    }
    
    func fetchHero(id: Int) -> Hero? {
        return allHeroes.first { Int($0.heroID) == id }
    }
    
    func fetchHeroWithID(id: Int) throws -> ODHero {
        guard let hero = heroes["\(id)"] else {
            throw D2AError(message: "Cannot find hero")
        }
        return hero
    }
    
    func fetchGameMode(id: Int) -> GameMode? {
        return persistanceProvider.fetchGameMode(id: id)
    }
    
    func fetchItem(id: Int) -> Item? {
        guard id == 0 else {
            guard let itemString = itemIDTable["\(id)"] else {
                return nil
            }
            guard let item = items[itemString] else {
                return nil
            }
            return item
        }
        return nil
    }
    
    func fetchRegion(id: String) -> String {
        guard let region = regions[id] else {
            return "Unknown"
        }
        return region
    }
    
    func fetchLobby(id: Int) -> LobbyType {
        return lobbyTypes["\(id)"] ?? LobbyType(id: id, name: "Unknown Lobby")
    }
    
    func fetchAbilityName(id: Int) -> String? {
        guard let abilityName = abilityIDTable["\(id)"] else {
            return nil
        }
        return abilityName
    }
    
    func fetchOpenDotaAbility(name: String) -> ODAbility? {
        return abilities[name]
    }
    
    func fetchStratzAbility(name: String) -> StratzAbility? {
        let ability = apolloAbilities.first { $0.name == name }
        return ability
    }
    
    func fetchHeroAbility(name: String) -> [String] {
        let abilities = heroAbilities[name]?.abilities
        return abilities ?? []
    }
    
    func fetchAllHeroes() -> [ODHero] {
        var sortedHeroes = [ODHero]()
        for i in 1..<150 {
            if let hero = heroes["\(i)"] {
                sortedHeroes.append(hero)
            }
        }
        
        sortedHeroes.sort { hero1, hero2 in
            return hero1.localizedName < hero2.localizedName
        }
        return sortedHeroes
    }
    
    func fetchSearchedHeroes(text: String) -> [ODHero] {
        return []
    }
    
    func getTalentDisplayName(id: Short) -> String {
        return getTalentDisplayName(talentID: Int(id))
    }
    
    private func getTalentDisplayName(talentID: Int) -> String {
        let talent = apolloAbilities.first { ability in
            return ability.id == talentID
        }
        return talent?.language?.displayName ?? "Fetch String Error"
    }
    
    // MARK: - Save Constant Data
    @MainActor
    private func loadConstantData() async {
        isLoading = true
        async let heroes = openDotaProvider.loadHeroes()
        async let abilities = openDotaProvider.loadAbilities()
        async let modes = openDotaProvider.loadGameModes()
        async let regions = openDotaProvider.loadRegions()
        async let patches = openDotaProvider.loadPatches()
        
        do {
            let fetchedHeroes = try await heroes
            let fetchedAbilities = try await abilities
            let fetchedModes = try await modes
            let fetchedRegions = try await regions
            let fetchedPatches = try await patches
            
            await saveODData(data: fetchedHeroes, type: Hero.self)
            await saveODData(data: fetchedAbilities, type: Ability.self)
            await saveODData(data: fetchedModes, type: GameMode.self)
            await saveODData(data: fetchedPatches, type: Patch.self)
            saveRegions(regions: fetchedRegions)
        } catch {
            try? persistanceProvider.loadDefaultData()
        }
        fetchHeroes()
        isLoading = false
    }
    
    private func saveRegions(regions: [String: String]) {
        let context = persistanceProvider.makeContext(author: "Regions")
        for (regionIDString, regionName) in regions {
            guard let regionID = Int(regionIDString) else {
                logError("Region ID is not an integer. regionID: \(regionIDString)", category: .coredata)
                continue
            }
            do {
                try context.persistent(mapping: ["id": regionID, "name": regionName], to: Region.self, id: regionID)
            } catch {
                logError("Not able to persist region data. \(error)", category: .coredata)
                continue
            }
        }
    }
    
    func resetHeroData(context: NSManagedObjectContext) {
        do {
            deleteData(Hero.self, in: context)
            deleteData(Ability.self, in: context)
            deleteData(GameMode.self, in: context)
            deleteData(Patch.self, in: context)
            try context.save()
        } catch {
            logError("Reset failed: \(error)", category: .coredata)
        }
        Task {
            await loadConstantData()
        }
    }
    
    private func deleteData<T: NSManagedObject>(_ type: T.Type, in context: NSManagedObjectContext) {
        do {
            let objects = try context.fetch(T.fetchRequest()) as? [T] ?? []
            for object in objects {
                context.delete(object)
            }
        } catch {
            logError("Failed to fetch data: \(type)", category: .coredata)
        }
    }
    
    // MARK: - Save constant data
    private func saveODData<T: NSManagedObject>(data: [PersistanceModel], type: T.Type) {
        saveODData(data: data, type: type, mainContext: false)
    }
    
    private func saveODData<T: NSManagedObject>(data: [PersistanceModel], type: T.Type, mainContext: Bool) {
        let useMainContext = data.count <= 5 || mainContext
        let context = useMainContext ? persistanceProvider.mainContext : persistanceProvider.makeContext(author: "ODData")
        
        if useMainContext || context.hasData(for: type) {
            updateData(data: data, context: context, tracking: type.entity().name ?? "NO_ENTITY_NAME")
        } else {
            batchInsertData(data, into: type.entity(), context: context)
        }
    }
    
    // MARK: - Save Specific data
    private func updateData(data: [PersistanceModel], context: NSManagedObjectContext, tracking: String = "") {
        context.perform {
            #if DEBUG
            DispatchQueue.main.async {
                let hud = HUDController.shared
                hud.createHUD(title: tracking, total: data.count)
            }
            #endif
            for object in data {
                do {
                    _ = try object.update(context: context)
                } catch {
                    logError("An error occured when updating data in Core Data \(error.localizedDescription)", category: .coredata)
                }
                #if DEBUG
                DispatchQueue.main.async {
                    let hud = HUDController.shared
                    hud.updateHUD(title: tracking)
                }
                #endif
            }
            do {
                if context.hasChanges {
                    try context.save()
                }
            } catch {
                logError("An error occured when save data in Core Data \(error.localizedDescription)", category: .coredata)
            }
        }
    }
    
    private func batchInsertData(_ data: [PersistanceModel], into entity: NSEntityDescription, context: NSManagedObjectContext) {
        context.batchInsert(dictionary: data.map{ $0.dictionaries }, into: entity)
    }
}
