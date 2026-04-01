//
//  Hero.swift
//  D2A
//
//  Created by Shibo Tong on 29/9/2022.
//

import Foundation
import CoreData
import StratzAPI

extension Hero {
    // MARK: - Error
    enum CoreDataError: Error {
        case decodingError
    }
    
    // MARK: - Static func
    /// Create `Hero` with `HeroModel` and `HeroQuery.Data.Constants.Hero` and save into Core Data
    static func createHero(_ queryHero: HeroQuery.Data.Constants.Hero, model: HeroCodable, abilities: [String] = []) throws -> Hero {
        let viewContext = PersistanceController.shared.container.viewContext
        
        guard let heroID = queryHero.id,
              let heroTalents = queryHero.talents,
              let heroRoles = queryHero.roles,
              let heroStats = queryHero.stats else {
            throw Hero.CoreDataError.decodingError
        }
        let hero = fetchHero(id: heroID) ?? Hero(context: viewContext)
        // data from Stratz
        hero.lastFetch = Date()
        hero.id = heroID
        hero.displayName = queryHero.displayName
        hero.name = queryHero.name
        hero.complexity = Int16(heroStats.complexity ?? 0)
        hero.visionDaytimeRange = heroStats.visionDaytimeRange ?? 1800
        hero.visionNighttimeRange = heroStats.visionNighttimeRange ?? 800
        hero.roles = NSSet(array: try heroRoles.map({ return try Role.createRole($0) }))
        hero.talents = NSSet(array: try heroTalents.map({ return try Talent.createTalent($0) }))
        
        // data from OpenDota
        hero.abilities = abilities
        hero.primaryAttr = model.primaryAttr
        hero.attackType = model.attackType
        hero.img = model.img
        hero.icon = model.icon
        
        hero.baseHealth = model.baseHealth
        hero.baseHealthRegen = model.baseHealthRegen
        hero.baseMana = model.baseMana
        hero.baseManaRegen = model.baseManaRegen
        hero.baseArmor = model.baseArmor
        hero.baseMr = model.baseMr
        hero.baseAttackMin = model.baseAttackMin
        hero.baseAttackMax = model.baseAttackMax
        
        hero.baseStr = model.baseStr
        hero.baseAgi = model.baseAgi
        hero.baseInt = model.baseInt
        hero.gainStr = model.strGain
        hero.gainAgi = model.agiGain
        hero.gainInt = model.intGain
        
        hero.attackRange = model.attackRange
        hero.projectileSpeed = model.projectileSpeed
        hero.attackRate = model.attackRate
        hero.moveSpeed = model.moveSpeed
        hero.turnRate = model.turnRate ?? 0.6
        
        try viewContext.save()
        return hero
    }
    
    /// Fetch `Hero` with `id` in CoreData
    static func fetchHero(id: Double) -> Hero? {
        let viewContext = PersistanceController.shared.container.viewContext
        let fetchHero: NSFetchRequest<Hero> = Hero.fetchRequest()
        fetchHero.predicate = NSPredicate(format: "id == %f", id)
        
        let results = try? viewContext.fetch(fetchHero)
        return results?.first
    }
    
    // MARK: - Static let
    static let strMaxHP: Int32 = 20
    static let strHPRegen = 0.1
    
    static let agiArmor = 0.16666666666666667
    static let agiAttackSpeed: Int32 = 1
    
    static let intMaxMP: Int32 = 12
    static let intManaRegen = 0.05
    
    // MARK: - Variables
    var heroNameLowerCase: String {
        return name?.replacingOccurrences(of: "npc_dota_hero_", with: "") ?? "no_name"
    }

    var heroNameLocalized: String {
        return NSLocalizedString(displayName ?? "no_name", comment: "")
    }
    
    enum HeroHPMana: String {
        case hp = "HP"
        case mana = "Mana"
    }
    
    // MARK: - functions
    
    /// calculate hero HP or Mana based on Level
    /// - Parameters:
    ///    - level: Level of `Hero`
    ///    - type: `HeroHPMana` type of calculation
    ///  - return: a `Int` value indicate hp or mana for current level
    func calculateHPManaByLevel(level: Double, type: HeroHPMana) -> Int {
        let attr: HeroAttribute = type == .hp ? .str : .int
        let base = type == .hp ? baseHealth : baseMana
        let max = type == .hp ? Hero.strMaxHP : Hero.intMaxMP
        let totalStat = calculateAttribute(level: level, attr: attr)
        let value = Int(base + totalStat * max)
        return value
    }
    
    func calculateHPLevel(level: Double) -> Int {
        let totalStr = calculateAttribute(level: level, attr: .str)
        let hp = Int(baseHealth + totalStr * Hero.strMaxHP)
        return hp
    }
    
    func calculateManaLevel(level: Double) -> Int {
        let totalInt = calculateAttribute(level: level, attr: .int)
        let hp = Int(baseMana + totalInt * Hero.intMaxMP)
        return hp
    }
    
    /// calculate hero HP or Mana regen based on Level
    /// - Parameters:
    ///    - level: Level of `Hero`
    ///    - type: `HeroHPMana` type of calculation
    ///  - return: a `Double` value indicate hp or mana regen  for current level
    func calculateHPManaRegenByLevel(level: Double, type: HeroHPMana) -> Double {
        let attr: HeroAttribute = type == .hp ? .str : .int
        let base = type == .hp ? baseHealthRegen : baseManaRegen
        let regen = type == .hp ? Hero.strHPRegen : Hero.intManaRegen
        let totalStat = calculateAttribute(level: level, attr: attr)
        let value = base + Double(totalStat) * regen
        return value
    }
    
    func calculateHPRegen(level: Double) -> Double {
        let totalStr = calculateAttribute(level: level, attr: .str)
        let regen = baseHealthRegen + Double(totalStr) * Hero.strHPRegen
        return regen
    }
    
    func calculateMPRegen(level: Double) -> Double {
        let totalInt = calculateAttribute(level: level, attr: .int)
        let regen = baseManaRegen + Double(totalInt) * Hero.intManaRegen
        return regen
    }
    
    func calculateAttribute(level: Double, attr: HeroAttribute) -> Int32 {
        var base: Int32 = 0
        var gain = 0.0
        switch attr {
        case .str:
            base = baseStr
            gain = gainStr
        case .agi:
            base = baseAgi
            gain = gainAgi
        case .int:
            base = baseInt
            gain = gainInt
        default:
            base = 0
            gain = 0
        }
        var total = base + Int32((level - 1) * gain)
        total = levelBonusAttribute(base: total, level: level)
        return Int32(total)
    }
    
    /// calculate hero attack  based on Level
    /// - Parameters:
    ///    - level: Level of `Hero`
    ///    - isMin: if the number is min attack or max attack
    ///  - return: a `Int32` value indicate attack for current level
    func calculateAttackByLevel(level: Double, isMin: Bool) -> Int32 {
        let baseAttack = isMin ? baseAttackMin : baseAttackMax
        var bonusAttack: Int32 = 0
        switch primaryAttr {
        case "all":
            bonusAttack = Int32(Double(calculateAttribute(level: level, attr: .str) +
                                       calculateAttribute(level: level, attr: .agi) +
                                       calculateAttribute(level: level, attr: .int)) * 0.7)
        case "str", "int", "agi":
            bonusAttack = calculateAttribute(level: level, attr: HeroAttribute(rawValue: primaryAttr!)!)
        default:
            bonusAttack = 0
        }
        return baseAttack + bonusAttack
    }
    
    /// calculate hero armor based on Level
    /// - Parameters:
    ///    - level: Level of `Hero`
    ///  - return: a `Double` value indicate armor for current level
    func calculateArmorByLevel(level: Double) -> Double {
        let armor = baseArmor + Hero.agiArmor * Double(calculateAttribute(level: level, attr: .agi))
        return armor
    }
    
    func getGain(type: HeroAttribute) -> Double {
        switch type {
        case .all:
            return 0.0
        case .str:
            return gainStr
        case .agi:
            return gainAgi
        case .int:
            return gainInt
        case .whole:
            return 0.0
        }
    }
    
    private func levelBonusAttribute(base: Int32, level: Double) -> Int32 {
        // 17, 19, 21, 22, 23, 24, 26 +2 all attributes
        var bonus: Int32 = 0
        if level >= 17 {
            bonus += 2
        }
        if level >= 19 {
            bonus += 2
        }
        if level >= 21 {
            bonus += 2
        }
        if level >= 22 {
            bonus += 2
        }
        if level >= 23 {
            bonus += 2
        }
        if level >= 24 {
            bonus += 2
        }
        if level >= 26 {
            bonus += 2
        }
        return base + bonus
    }
    
    static func save(id: Int, data: [String: Any], in context: NSManagedObjectContext, logger: DataSyncingLogger? = nil) throws {
        let fetchRequest = Hero.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", Double(id))
        fetchRequest.predicate = predicate
        let hero = try context.fetch(fetchRequest).first ?? Hero(context: context)
        
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
}
