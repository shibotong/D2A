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
        return try? context.fetchOne(type: Hero.self, predicate: predicate)
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
    
    var displayName: String {
        heroNameLocalized
    }

    var heroNameLocalized: String {
        let translation = try? translation(for: .english)
        return translation?.displayName ?? "no_name"
    }
    
    var lore: String {
        let translation = try? translation(for: .english)
        return translation?.lore ?? "No lore"
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
    
    func updateTranslation(translation: HeroTranslation?) {
        guard let translation else {
            return
        }
        let language = translation.language
        guard var translations else {
            translations = [translation]
            return
        }
        guard let indexOfLanguage = translations.firstIndex(where: { $0.language == language }) else {
            translations.append(translation)
            return
        }
            
        let existingTranslation = translations[indexOfLanguage]
        if existingTranslation == translation {
            return
        }
        translations[indexOfLanguage] = translation
    }
    
    private func translation(for language: LocaliseLanguage = .english) throws -> HeroTranslation {
        guard let translation = translations?.first(where: { $0.language == language }) else {
            throw D2AError(message: "Not able to find translation for \(language)")
        }
        return translation
    }
}
