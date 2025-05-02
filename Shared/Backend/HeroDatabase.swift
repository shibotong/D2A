//
//  HeroDatabase.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import SwiftUI
import StratzAPI
import CoreData

enum LoadingStatus {
    case loading, error, finish
}

class HeroDatabase: ObservableObject {
    
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
    private var abilities = [String: Ability]()
    private var heroAbilities = [String: HeroAbility]()
    private var scepterData = [HeroScepter]()
    private var apolloAbilities = [StratzAbility]()
    
    static var shared = HeroDatabase()
    
    static var preview = HeroDatabase()
    
    let url = "https://api.opendota.com/api/herostats"
    
    private let stratzProvider: StratzProviding
    private let openDotaProvider: OpenDotaConstantProviding
    
    init(stratzProvider: StratzProviding = StratzController.shared,
         openDotaProvider: OpenDotaConstantProviding = OpenDotaConstantProvider.shared) {
        self.stratzProvider = stratzProvider
        self.openDotaProvider = openDotaProvider
        loadData()
    }
    
    func loadData() {
        gameModes = loadGameModes()
        regions = loadRegion()!
        lobbyTypes = loadLobby()!
        
        Task { [weak self] in
            async let idTable = loadItemIDs()
            async let items = loadItems()
            async let heroes = loadHeroes()
            async let abilityIDTable = loadAbilityID()
            async let abilities = loadAbilities()
            async let heroAbilities = loadHeroAbilities()
            async let scepter = loadScepter()
            async let stratzAbilities = self?.stratzProvider.loadAbilities()
            
            self?.itemIDTable = await idTable
            self?.items = await items
            self?.heroes = await heroes
            self?.abilityIDTable = await abilityIDTable
            self?.abilities = await abilities
            self?.heroAbilities = await heroAbilities
            self?.scepterData = await scepter
            self?.apolloAbilities = await stratzAbilities ?? []
            
            await self?.loadODHeroes()
        }
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
        if id == 0 {
            return nil
        } else {
            guard let itemString = itemIDTable["\(id)"] else {
                return nil
            }
            guard let item = items[itemString] else {
                return nil
            }
            return item
        }
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
    
    func fetchOpenDotaAbility(name: String) -> Ability? {
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
    
    func getAbilityScepterDesc(ability: Ability, heroID: Int) -> String? {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return nil
        }
        if ability.dname == hero.scepterSkillName {
            return hero.scepterDesc
        }
        return nil
    }
    
    func isScepterSkill(ability: Ability, heroID: Int) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        return ability.dname == hero.scepterSkillName && hero.scepterNewSkill
    }
    
    func isShardSkill(ability: Ability, heroID: Int) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        return ability.dname == hero.shardSkillName && hero.shardNewSkill
    }
    
    func hasScepter(ability: Ability, heroID: Int) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        return ability.dname == hero.scepterSkillName
    }
    
    func hasShard(ability: Ability, heroID: Int) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        if ability.dname == hero.shardSkillName {
            return true
        } else {
            return false
        }
    }
    
    func getAbilityShardDesc(ability: Ability, heroID: Int) -> String? {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
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
    
    private func loadODHeroes() async {
        let heroes = await openDotaProvider.loadHeroes()
        var heroesArray: [ODHero] = []
        for (key, value) in heroes {
            heroesArray.append(value)
        }
        await saveODHeroes(heroes: heroesArray)
    }
    
    private func saveODHeroes(heroes: [ODHero]) async {
        let viewContext = PersistanceController.shared.container.newBackgroundContext()
        if await hasHeroData(context: viewContext) {
            await updateHeroesData(heroes: heroes, context: viewContext)
        } else {
            await batchInsertHeroes(heroes: heroes, context: viewContext)
        }
    }
    
    private func updateHeroesData(heroes: [ODHero], context: NSManagedObjectContext) async {
        for openDotaHero in heroes {
            var hero = await Hero.fetch(id: Double(openDotaHero.id), context: context) ?? Hero(context: context)
            await context.perform {
                setIfNotEqual(entity: hero, path: \.id, value: Double(openDotaHero.id))
                setIfNotEqual(entity: hero, path: \.displayName, value: openDotaHero.localizedName)
                setIfNotEqual(entity: hero, path: \.primaryAttr, value: openDotaHero.primaryAttr)
                setIfNotEqual(entity: hero, path: \.attackType, value: openDotaHero.attackType)
                setIfNotEqual(entity: hero, path: \.img, value: openDotaHero.img)
                setIfNotEqual(entity: hero, path: \.icon, value: openDotaHero.icon)
                
                setIfNotEqual(entity: hero, path: \.baseHealth, value: openDotaHero.baseHealth)
                setIfNotEqual(entity: hero, path: \.baseHealthRegen, value: openDotaHero.baseHealthRegen)
                setIfNotEqual(entity: hero, path: \.baseMana, value: openDotaHero.baseMana)
                setIfNotEqual(entity: hero, path: \.baseManaRegen, value: openDotaHero.baseManaRegen)
                setIfNotEqual(entity: hero, path: \.baseArmor, value: openDotaHero.baseArmor)
                setIfNotEqual(entity: hero, path: \.baseMr, value: openDotaHero.baseMr)
                setIfNotEqual(entity: hero, path: \.baseAttackMin, value: openDotaHero.baseAttackMin)
                setIfNotEqual(entity: hero, path: \.baseAttackMax, value: openDotaHero.baseAttackMax)
                
                setIfNotEqual(entity: hero, path: \.baseStr, value: openDotaHero.baseStr)
                setIfNotEqual(entity: hero, path: \.baseAgi, value: openDotaHero.baseAgi)
                setIfNotEqual(entity: hero, path: \.baseInt, value: openDotaHero.baseInt)
                setIfNotEqual(entity: hero, path: \.gainStr, value: openDotaHero.strGain)
                setIfNotEqual(entity: hero, path: \.gainAgi, value: openDotaHero.agiGain)
                setIfNotEqual(entity: hero, path: \.gainInt, value: openDotaHero.intGain)
                
                setIfNotEqual(entity: hero, path: \.attackRange, value: openDotaHero.attackRange)
                setIfNotEqual(entity: hero, path: \.projectileSpeed, value: openDotaHero.projectileSpeed)
                setIfNotEqual(entity: hero, path: \.attackRate, value: openDotaHero.attackRate)
                setIfNotEqual(entity: hero, path: \.moveSpeed, value: openDotaHero.moveSpeed)
                setIfNotEqual(entity: hero, path: \.turnRate, value: openDotaHero.turnRate ?? 0.6)
                
                if hero.hasChanges {
                    do {
                        try context.save()
                        logDebug("Save hero \(openDotaHero.id) success", category: .coredata)
                    } catch {
                        logError("\(openDotaHero.id) save failed. \(error)", category: .coredata)
                    }
                }
            }
        }
    }
    
    private func batchInsertHeroes(heroes: [ODHero], context: NSManagedObjectContext) async {
        let insertRequest = NSBatchInsertRequest(entityName: "Hero", objects: heroes.map { $0.dictionaries })
        insertRequest.resultType = .count
        await context.perform {
            do {
                let fetchResult = try context.execute(insertRequest)
                if let batchInsertResult = fetchResult as? NSBatchInsertResult,
                   let success = batchInsertResult.result as? Bool {
                    return
                }
            } catch {
                logError("An error occured in batch insertint heroes \(error.localizedDescription)", category: .coredata)
            }
        }
    }
    
    private func hasHeroData(context: NSManagedObjectContext) async -> Bool {
        let request = Hero.fetchRequest()
        request.fetchLimit = 1
        return await context.perform {
            do {
                let count = try context.count(for: request)
                return count > 0
            } catch {
                logError("Cannot count number of heroes saved in Core Data", category: .coredata)
                return true
            }
        }
    }
}
