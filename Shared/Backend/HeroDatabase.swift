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
    private var abilities = [String: ODAbility]()
    private var heroAbilities = [String: ODHeroAbilities]()
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
            
            await self?.loadConstantData()
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
    
    func isScepterSkill(ability: ODAbility, heroID: Int) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        return ability.dname == hero.scepterSkillName && hero.scepterNewSkill
    }
    
    func isShardSkill(ability: ODAbility, heroID: Int) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        return ability.dname == hero.shardSkillName && hero.shardNewSkill
    }
    
    func hasScepter(ability: ODAbility, heroID: Int) -> Bool {
        guard let hero = scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        return ability.dname == hero.scepterSkillName
    }
    
    func hasShard(ability: ODAbility, heroID: Int) -> Bool {
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
    
    func getAbilityShardDesc(ability: ODAbility, heroID: Int) -> String? {
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
    
    // MARK: - Save Constant Data
    private func loadConstantData() async {
        let context = PersistanceController.shared.container.newBackgroundContext()
        await loadODHeroes(context: context)
        await loadODAbilities(context: context)
        await saveAbilitiesToHero(context: context)
    }
    
    // MARK: - Save abilities to heroes
    
    private func saveAbilitiesToHero(context: NSManagedObjectContext) async {
        let heroAbilities = await openDotaProvider.loadAbilitiesForHeroes()
        for (name, heroAbility) in heroAbilities {
            guard let hero = await Hero.fetchByName(name: name, context: context) else {
                logError("Cannot find hero: \(name)", category: .coredata)
                continue
            }
            let abilityNames = heroAbility.abilities
            
            if let currentAbilities = hero.abilities?.compactMap({ ($0 as? Ability) }) {
                guard currentAbilities.compactMap(\.name) != abilityNames else {
                    continue
                }
                await context.perform {
                    for ability in currentAbilities {
                        hero.removeFromAbilities(ability)
                    }
                }
            }
            
            let abilities = await Ability.fetchByNames(names: abilityNames, context: context)
            
            await context.perform {
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
    
    // MARK: - Save Abilities
    
    private func loadODAbilities(context: NSManagedObjectContext) async {
        let abilities = await openDotaProvider.loadAbilities()
        await saveODAbilities(abilities: abilities, context: context)
    }
    
    private func saveODAbilities(abilities: [ODAbility], context: NSManagedObjectContext) async {
        if await hasData(for: Ability.self, context: context) {
            await updateAbilitiesData(abilities: abilities, context: context)
        } else {
            await batchInsertData(abilities, into: Ability.entity(), context: context)
        }
    }
    
    private func updateAbilitiesData(abilities: [ODAbility], context: NSManagedObjectContext) async {
        for openDotaAbility in abilities {
            guard let abilityID = openDotaAbility.id else {
                continue
            }
            let ability = await Ability.fetch(id: abilityID, context: context) ?? Ability(context: context)
            await context.perform {
                setIfNotEqual(entity: ability, path: \.id, value: Int32(abilityID))
                setIfNotEqual(entity: ability, path: \.name, value: openDotaAbility.name)
                setIfNotEqual(entity: ability, path: \.behavior, value: openDotaAbility.behavior?.transformString())
                setIfNotEqual(entity: ability, path: \.bkbPierce, value: openDotaAbility.bkbPierce?.transformString())
                setIfNotEqual(entity: ability, path: \.coolDown, value: openDotaAbility.coolDown?.transformString())
                setIfNotEqual(entity: ability, path: \.damageType, value: openDotaAbility.damageType?.transformString())
                setIfNotEqual(entity: ability, path: \.desc, value: openDotaAbility.desc)
                setIfNotEqual(entity: ability, path: \.dispellable, value: openDotaAbility.dispellable?.transformString())
                setIfNotEqual(entity: ability, path: \.displayName, value: openDotaAbility.dname)
                setIfNotEqual(entity: ability, path: \.img, value: openDotaAbility.img)
                setIfNotEqual(entity: ability, path: \.lore, value: openDotaAbility.lore)
                setIfNotEqual(entity: ability, path: \.manaCost, value: openDotaAbility.manaCost?.transformString())
                setIfNotEqual(entity: ability, path: \.targetTeam, value: openDotaAbility.targetTeam?.transformString())
                setIfNotEqual(entity: ability, path: \.targetType, value: openDotaAbility.targetType?.transformString())
                setIfNotEqual(entity: ability, path: \.attributes, value: openDotaAbility.attributes?.compactMap { AbilityAttribute(attribute: $0) })
                if ability.hasChanges {
                    do {
                        try context.save()
                        logDebug("Save ability \(ability.id) success", category: .coredata)
                    } catch {
                        logError("\(ability.id) save failed. \(error)", category: .coredata)
                    }
                }
            }
        }
    }
    
    // MARK: - Save Heroes
    
    private func loadODHeroes(context: NSManagedObjectContext) async {
        let heroes = await openDotaProvider.loadHeroes()
        var heroesArray: [ODHero] = []
        for (_, value) in heroes {
            heroesArray.append(value)
        }
        await saveODHeroes(heroes: heroesArray, viewContext: context)
    }
    
    private func saveODHeroes(heroes: [ODHero], viewContext: NSManagedObjectContext) async {
        if await hasData(for: Hero.self, context: viewContext) {
            await updateHeroesData(heroes: heroes, context: viewContext)
        } else {
            await batchInsertData(heroes, into: Hero.entity(), context: viewContext)
        }
    }
    
    private func updateHeroesData(heroes: [ODHero], context: NSManagedObjectContext) async {
        for openDotaHero in heroes {
            await context.perform {
                let hero = Hero.fetch(id: Double(openDotaHero.id), context: context) ?? Hero(context: context)
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
    
    private func batchInsertData<T: D2ABatchInsertable, V: NSEntityDescription>(_ data: [T], into entity: V, context: NSManagedObjectContext) async {
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
    
    private func hasData<T: NSManagedObject>(for entity: T.Type, context: NSManagedObjectContext) async -> Bool {
        let request = T.fetchRequest()
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
