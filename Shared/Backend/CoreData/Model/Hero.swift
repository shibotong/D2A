//
//  Hero.swift
//  D2A
//
//  Created by Shibo Tong on 29/9/2022.
//

import CoreData
import Foundation
import StratzAPI
import SwiftUI

extension Hero {
    // MARK: - Error
    enum CoreDataError: Error {
        case decodingError
    }

    // MARK: - Static func
    /// Create `Hero` with `HeroModel` and `HeroQuery.Data.Constants.Hero` and save into Core Data
    static func createHero(
        _ queryHero: HeroQuery.Data.Constants.Hero, model: ODHero, abilities: [String] = []
    ) throws -> Hero {
        let viewContext = PersistanceProvider.shared.container.viewContext

        guard let heroID = queryHero.id,
            let heroTalents = queryHero.talents,
            let heroRoles = queryHero.roles,
            let heroStats = queryHero.stats
        else {
            throw Hero.CoreDataError.decodingError
        }
        let hero = fetch(id: Int(heroID), context: viewContext) ?? Hero(context: viewContext)
        // data from Stratz
        hero.lastFetch = Date()
        hero.id = heroID
        hero.name = queryHero.name
        hero.complexity = Int16(heroStats.complexity ?? 0)
        hero.visionDaytimeRange = heroStats.visionDaytimeRange ?? 1800
        hero.visionNighttimeRange = heroStats.visionNighttimeRange ?? 800

        // data from OpenDota
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
    static func fetch(id: Int, context: NSManagedObjectContext) -> Hero? {
        let predicate = NSPredicate(format: "id == %f", Double(id))
        return fetchOne(predicate: predicate, context: context)
    }

    static func fetchByName(name: String, context: NSManagedObjectContext) -> Hero? {
        let predicate = NSPredicate(format: "name == %@", name)
        return fetchOne(predicate: predicate, context: context)
    }

    static func fetchOne(predicate: NSPredicate, context: NSManagedObjectContext) -> Hero? {
        let request = Hero.fetchRequest()
        request.predicate = predicate
        return context.performAndWait {
            do {
                guard let result = try context.fetch(request).first else {
                    return nil
                }
                return result
            } catch {
                logError("Failed to fetch Hero: \(error)", category: .coredata)
                return nil
            }
        }
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
        let translation = try? translation(for: "en")
        return translation?.displayName ?? "no_name"
    }
    
    var attribute: HeroAttribute {
        guard let primaryAttr else {
            logError("Hero \(id) doesn't have attribute", category: .constants)
            return .uni
        }
        guard let attribute = HeroAttribute(rawValue: primaryAttr) else {
            logError("Hero \(id) doesn't have a valid attribute", category: .constants)
            return .uni
        }
        return attribute
    }

    enum HeroHPMana: String, CaseIterable {
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
        let base = type == .hp ? Int(baseHealth) : Int(baseMana)
        let max = type == .hp ? Int(Hero.strMaxHP) : Int(Hero.intMaxMP)
        let totalStat = calculateAttribute(level: level, attr: attr)
        let value = base + totalStat * max
        return value
    }

    private func calculateHPLevel(level: Double) -> Int {
        let totalStr = calculateAttribute(level: level, attr: .str)
        let hp = Int(baseHealth) + totalStr * Int(Hero.strMaxHP)
        return hp
    }

    private func calculateManaLevel(level: Double) -> Int {
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

    private func calculateHPRegen(level: Double) -> Double {
        let totalStr = calculateAttribute(level: level, attr: .str)
        let regen = baseHealthRegen + Double(totalStr) * Hero.strHPRegen
        return regen
    }

    private func calculateMPRegen(level: Double) -> Double {
        let totalInt = calculateAttribute(level: level, attr: .int)
        let regen = baseManaRegen + Double(totalInt) * Hero.intManaRegen
        return regen
    }

    func calculateAttribute(level: Double, attr: HeroAttribute) -> Int {
        let base = getBase(type: attr)
        let gain = getGain(type: attr)
        var total = base + Int((level - 1) * gain)
        total = Int(levelBonusAttribute(base: Int32(total), level: level))
        return total
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
            bonusAttack = Int32(
                Double(
                    calculateAttribute(level: level, attr: .str)
                        + calculateAttribute(level: level, attr: .agi)
                        + calculateAttribute(level: level, attr: .int)) * 0.7)
        case "str", "int", "agi":
            bonusAttack = Int32(calculateAttribute(
                level: level, attr: HeroAttribute(rawValue: primaryAttr!)!))
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
    
    func getBase(type: HeroAttribute) -> Int {
        switch type {
        case .str:
            return Int(baseStr)
        case .agi:
            return Int(baseAgi)
        case .int:
            return Int(baseInt)
        default:
            return 0
        }
    }

    func getGain(type: HeroAttribute) -> Double {
        switch type {
        case .uni:
            return 0.0
        case .str:
            return gainStr
        case .agi:
            return gainAgi
        case .int:
            return gainInt
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

    func saveODData(context: NSManagedObjectContext, openDotaHero: ODHero) {
        setIfNotEqual(entity: self, path: \.id, value: Double(openDotaHero.id))
        setIfNotEqual(entity: self, path: \.primaryAttr, value: openDotaHero.primaryAttr)
        setIfNotEqual(entity: self, path: \.attackType, value: openDotaHero.attackType)
        setIfNotEqual(entity: self, path: \.rolesCollection, value: openDotaHero.roles)
        setIfNotEqual(entity: self, path: \.img, value: openDotaHero.img)
        setIfNotEqual(entity: self, path: \.icon, value: openDotaHero.icon)
        setIfNotEqual(entity: self, path: \.abilities, value: openDotaHero.abilities)

        setIfNotEqual(entity: self, path: \.baseHealth, value: openDotaHero.baseHealth)
        setIfNotEqual(entity: self, path: \.baseHealthRegen, value: openDotaHero.baseHealthRegen)
        setIfNotEqual(entity: self, path: \.baseMana, value: openDotaHero.baseMana)
        setIfNotEqual(entity: self, path: \.baseManaRegen, value: openDotaHero.baseManaRegen)
        setIfNotEqual(entity: self, path: \.baseArmor, value: openDotaHero.baseArmor)
        setIfNotEqual(entity: self, path: \.baseMr, value: openDotaHero.baseMr)
        setIfNotEqual(entity: self, path: \.baseAttackMin, value: openDotaHero.baseAttackMin)
        setIfNotEqual(entity: self, path: \.baseAttackMax, value: openDotaHero.baseAttackMax)

        setIfNotEqual(entity: self, path: \.baseStr, value: openDotaHero.baseStr)
        setIfNotEqual(entity: self, path: \.baseAgi, value: openDotaHero.baseAgi)
        setIfNotEqual(entity: self, path: \.baseInt, value: openDotaHero.baseInt)
        setIfNotEqual(entity: self, path: \.gainStr, value: openDotaHero.strGain)
        setIfNotEqual(entity: self, path: \.gainAgi, value: openDotaHero.agiGain)
        setIfNotEqual(entity: self, path: \.gainInt, value: openDotaHero.intGain)

        setIfNotEqual(entity: self, path: \.attackRange, value: openDotaHero.attackRange)
        setIfNotEqual(entity: self, path: \.projectileSpeed, value: openDotaHero.projectileSpeed)
        setIfNotEqual(entity: self, path: \.attackRate, value: openDotaHero.attackRate)
        setIfNotEqual(entity: self, path: \.moveSpeed, value: openDotaHero.moveSpeed)
        setIfNotEqual(entity: self, path: \.turnRate, value: openDotaHero.turnRate ?? 0.6)
        
        setIfNotEqual(entity: self, path: \.visionDaytimeRange, value: Double(openDotaHero.dayVision))
        setIfNotEqual(entity: self, path: \.visionNighttimeRange, value: Double(openDotaHero.nightVision))
        
        setIfNotEqual(entity: self, path: \.talents, value: openDotaHero.talents)
    }
    
    private func translation(for language: String = "en") throws -> HeroTranslation {
        guard let translation = translations?.first(where: { $0.language == language }) else {
            throw D2AError(message: "Not able to find translation for \(language)")
        }
        return translation
    }
}
