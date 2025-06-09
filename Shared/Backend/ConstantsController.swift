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

enum LoadingStatus {
    case loading, error, finish
}

class ConstantsController: ObservableObject {

    enum HeroDataError: Error {
        case heroNotFound
    }

    private var heroes = [String: ODHero]()
    private var gameModes = [String: GameMode]()
    private var lobbyTypes = [String: LobbyType]()
    private var regions = [String: String]()
    private var items = [String: Item]()
    private var itemIDTable = [String: String]()
    private var abilityIDTable = [String: String]()
    private var abilities = [String: ODAbility]()
    private var heroAbilities = [String: ODHeroAbilities]()
    private var scepterData = [HeroScepter]()
    private var apolloAbilities = [StratzAbility]()

    static var shared = ConstantsController()

    static var preview = ConstantsController()

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
        Task {
            await loadData()
        }
    }

    @MainActor
    func loadData() async {
        gameModes = loadGameModes()
        regions = loadRegion()!
        lobbyTypes = loadLobby()!

        async let idTable = loadItemIDs()
        async let items = loadItems()
        async let heroes = loadHeroes()
        async let abilityIDTable = loadAbilityID()
        async let abilities = loadAbilities()
        async let heroAbilities = loadHeroAbilities()
        async let scepter = loadScepter()
        async let stratzAbilities = stratzProvider.loadAbilities()

        self.itemIDTable = await idTable
        self.items = await items
        self.heroes = await heroes
        self.abilityIDTable = await abilityIDTable
        self.abilities = await abilities
        self.heroAbilities = await heroAbilities
        self.scepterData = await scepter
        self.apolloAbilities = await stratzAbilities

        await loadConstantData()
    }

    func fetchHeroWithID(id: Int) throws -> ODHero {
        guard let hero = heroes["\(id)"] else {
            throw HeroDataError.heroNotFound
        }
        return hero
    }

    func fetchGameMode(id: Int) -> GameMode {
        return gameModes["\(id)"]!
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

    func getAbilityScepterDesc(ability: ODAbility, heroID: Int) -> String? {
        guard
            let hero = scepterData.filter({ scepter in
                scepter.id == heroID
            }).first
        else {
            // Cannot find this hero
            return nil
        }
        if ability.dname == hero.scepterSkillName {
            return hero.scepterDesc
        }
        return nil
    }

    func isScepterSkill(ability: ODAbility, heroID: Int) -> Bool {
        guard
            let hero = scepterData.filter({ scepter in
                scepter.id == heroID
            }).first
        else {
            // Cannot find this hero
            return false
        }
        return ability.dname == hero.scepterSkillName && hero.scepterNewSkill
    }

    func isShardSkill(ability: ODAbility, heroID: Int) -> Bool {
        guard
            let hero = scepterData.filter({ scepter in
                scepter.id == heroID
            }).first
        else {
            // Cannot find this hero
            return false
        }
        return ability.dname == hero.shardSkillName && hero.shardNewSkill
    }

    func hasScepter(ability: ODAbility, heroID: Int) -> Bool {
        guard
            let hero = scepterData.filter({ scepter in
                scepter.id == heroID
            }).first
        else {
            // Cannot find this hero
            return false
        }
        return ability.dname == hero.scepterSkillName
    }

    func hasShard(ability: ODAbility, heroID: Int) -> Bool {
        guard
            let hero = scepterData.filter({ scepter in
                scepter.id == heroID
            }).first
        else {
            // Cannot find this hero
            return false
        }
        guard ability.dname == hero.shardSkillName else {
            return false
        }
        return true
    }

    func getAbilityShardDesc(ability: ODAbility, heroID: Int) -> String? {
        guard
            let hero = scepterData.filter({ scepter in
                scepter.id == heroID
            }).first
        else {
            // Cannot find this hero
            return nil
        }
        if ability.dname == hero.shardSkillName {
            print("\(hero.shardDesc)")
            return hero.shardDesc
        }
        return nil
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
    private func loadConstantData() async {
        await loadODHeroes()
        await loadODAbilities()
        await saveAbilitiesToHero()
    }

    // MARK: - Save abilities to heroes

    private func saveAbilitiesToHero() async {
        let heroAbilities = await openDotaProvider.loadAbilitiesForHeroes()
        await persistanceProvider.saveAbilitiesToHero(heroAbilities: heroAbilities)
    }

    // MARK: - Save Abilities

    private func loadODAbilities() async {
        let abilities = await openDotaProvider.loadAbilities()
        await persistanceProvider.saveODAbilities(abilities: abilities)
    }

    // MARK: - Save Heroes

    private func loadODHeroes() async {
        let heroes = await openDotaProvider.loadHeroes()
        var heroesArray: [ODHero] = []
        for (_, value) in heroes {
            heroesArray.append(value)
        }
        await persistanceProvider.saveODHeroes(heroes: heroesArray)
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
