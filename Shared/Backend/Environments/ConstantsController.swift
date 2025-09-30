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
        
        do {
            let fetchedHeroes = try await heroes
            let fetchedAbilities = try await abilities
            let fetchedModes = try await modes
            let fetchedRegions = try await regions
            
            await persistanceProvider.saveODData(data: fetchedHeroes, type: Hero.self)
            await persistanceProvider.saveODData(data: fetchedAbilities, type: Ability.self)
            await persistanceProvider.saveODData(data: fetchedModes, type: GameMode.self)
            
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

    func resetHeroData(context: NSManagedObjectContext) async {
        await context.perform {
            do {
                let heroes = try context.fetch(Hero.fetchRequest())
                let abilities = try context.fetch(Ability.fetchRequest())
                for hero in heroes {
                    context.delete(hero)
                }
                for ability in abilities {
                    context.delete(ability)
                }
                try context.save()
            } catch {
                logError("Reset failed: \(error)", category: .coredata)
            }
        }
        await loadConstantData()
    }
}
