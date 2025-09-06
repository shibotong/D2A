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
        
        do {
            let fetchedHeroes = try await heroes
            let fetchedAbilities = try await abilities
            let fetchedModes = try await modes
            await persistanceProvider.saveODData(data: fetchedHeroes, type: Hero.self)
            await persistanceProvider.saveODData(data: fetchedAbilities, type: Ability.self)
            await persistanceProvider.saveODData(data: fetchedModes, type: GameMode.self)
        } catch {
            try? persistanceProvider.loadDefaultData()
        }
        fetchHeroes()
        isLoading = false
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
