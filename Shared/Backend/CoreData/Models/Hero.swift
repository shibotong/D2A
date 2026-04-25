//
//  Hero.swift
//  D2A
//
//  Created by Shibo Tong on 29/9/2022.
//

import Foundation
import CoreData
import StratzAPI

extension Hero: HeroProtocol {
    
    var heroName: String {
        return name ?? ""
    }
    
    var heroAbilities: [Ability] {
        return (abilities?.array as? [Ability]) ?? []
    }
    
    var talent1LeftName: String {
        talent1left?.displayName ?? ""
    }
    
    var talent2LeftName: String {
        talent2left?.displayName ?? ""
    }
    
    var talent3LeftName: String {
        talent3left?.displayName ?? ""
    }
    
    var talent4LeftName: String {
        talent4left?.displayName ?? ""
    }
    
    var talent1RightName: String {
        talent1right?.displayName ?? ""
    }
    
    var talent2RightName: String {
        talent2right?.displayName ?? ""
    }
    
    var talent3RightName: String {
        talent3right?.displayName ?? ""
    }
    
    var talent4RightName: String {
        talent4right?.displayName ?? ""
    }
    
    var hero: Hero {
        return self
    }
    
    var heroID: Int {
        Int(id)
    }
    
    var localizedName: String {
        guard let localization else {
            return displayName ?? ""
        }
        return localization.displayName ?? ""
    }
    
    private var localization: HeroTranslation? {
        guard let localizations = localizations?.allObjects as? [HeroTranslation] else {
            return nil
        }
        guard let targetLocalization = localizations.first(where: { $0.language == AppConfig.shared.languageCode.rawValue }) else {
            return nil
        }
        return targetLocalization
    }
    
    var primaryAttribute: String {
        primaryAttr ?? ""
    }
    
    var abilityData: [Ability] {
        []
    }
    
    // MARK: - Error
    enum CoreDataError: Error {
        case decodingError
    }
    
    // MARK: - Static func
    /// Create `Hero` with `HeroModel` and `HeroQuery.Data.Constants.Hero` and save into Core Data
    static func createHero(_ queryHero: HeroQuery.Data.Constants.Hero, model: HeroCodable, abilities: [String] = []) throws -> Hero {
        let viewContext = PersistenceProvider.shared.container.viewContext
        
        guard let heroID = queryHero.id,
              let heroTalents = queryHero.talents,
              let heroRoles = queryHero.roles,
              let heroStats = queryHero.stats else {
            throw Hero.CoreDataError.decodingError
        }
        let hero = (try? DataPersistenceService.shared.fetch(heroID: Int(heroID), context: viewContext)) ?? Hero(context: viewContext)
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
        
//        // data from OpenDota
//        hero.abilities = abilities
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
        let base = Int(type == .hp ? baseHealth : baseMana)
        let max = type == .hp ? Int(Hero.strMaxHP) : Int(Hero.intMaxMP)
        let totalStat = calculateAttribute(level: level, attr: attr)
        let value = Int(base + totalStat * max)
        return value
    }
    
    func calculateHPLevel(level: Double) -> Int {
        let totalStr = calculateAttribute(level: level, attr: .str)
        let hp = Int(baseHealth) + totalStr * Int(Hero.strMaxHP)
        return hp
    }
    
    func calculateManaLevel(level: Double) -> Int {
        let totalInt = calculateAttribute(level: level, attr: .int)
        let hp = Int(baseMana) + totalInt * Int(Hero.intMaxMP)
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
    
    func calculateAttribute(level: Double, attr: HeroAttribute) -> Int {
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
        return Int(total)
    }
    
    /// calculate hero attack  based on Level
    /// - Parameters:
    ///    - level: Level of `Hero`
    ///    - isMin: if the number is min attack or max attack
    ///  - return: a `Int32` value indicate attack for current level
    func calculateAttackByLevel(level: Double, isMin: Bool) -> Int {
        let baseAttack = isMin ? baseAttackMin : baseAttackMax
        var bonusAttack: Int32 = 0
        switch primaryAttr {
        case "all":
            bonusAttack = Int32(Double(calculateAttribute(level: level, attr: .str) +
                                       calculateAttribute(level: level, attr: .agi) +
                                       calculateAttribute(level: level, attr: .int)) * 0.7)
        case "str", "int", "agi":
            bonusAttack = Int32(calculateAttribute(level: level, attr: HeroAttribute(rawValue: primaryAttr!)!))
        default:
            bonusAttack = 0
        }
        return Int(baseAttack + bonusAttack)
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
}
