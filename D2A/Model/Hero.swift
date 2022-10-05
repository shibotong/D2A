//
//  Hero.swift
//  D2A
//
//  Created by Shibo Tong on 29/9/2022.
//

import Foundation
import CoreData

extension Hero {
    // MARK: - Error
    enum CoreDataError: Error {
        case decodingError
    }
    
    // MARK: - Static func
    /// Create `Hero` with `HeroModel` and `HeroQuery.Data.Constant.Hero` and save into Core Data
    static func createHero(_ queryHero: HeroQuery.Data.Constant.Hero, model: HeroModel, abilities: [String] = []) throws -> Hero {
        let viewContext = PersistenceController.shared.container.viewContext
        
        guard let heroID = queryHero.id,
              let heroTalents = queryHero.talents,
              let heroRoles = queryHero.roles else {
            throw Hero.CoreDataError.decodingError
        }
        let hero = Self.fetchHero(id: heroID) ?? Hero(context: viewContext)
        
        // data from Stratz
        hero.lastFetch = Date()
        hero.id = heroID
        hero.displayName = queryHero.displayName
        hero.name = queryHero.name
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
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        print("save hero successfully \(hero.id)")
        return hero
    }
    
    /// Fetch `Hero` with `id` in CoreData
    static func fetchHero(id: Double) -> Hero? {
        let viewContext = PersistenceController.shared.container.viewContext
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
        return self.name?.replacingOccurrences(of: "npc_dota_hero_", with: "") ?? "no_name"
    }

    var heroNameLocalized: String {
        return NSLocalizedString(self.displayName ?? "no_name", comment: "")
    }
    
    var calculateHP: Int32 {
        let hp = self.baseHealth + self.baseStr * Hero.strMaxHP
        return hp
    }
    var calculateHPRegen: Double {
        let regen = self.baseHealthRegen + Double(self.baseStr) * Hero.strHPRegen
        return regen
    }
    
    var calculateMP: Int32 {
        let mp = self.baseMana + self.baseInt * Hero.intMaxMP
        return mp
    }
    var calculateMPRegen: Double {
        let regen = self.baseManaRegen + Double(self.baseInt) * Hero.intManaRegen
        return regen
    }
    
    var calculatedAttackMin: Int32 {
        let mainAttributes = self.mainAttributes
        return self.baseAttackMin + mainAttributes
    }
    
    var calculatedAttackMax: Int32 {
        let mainAttributes = self.mainAttributes
        return self.baseAttackMax + mainAttributes
    }
    
    var calculateArmor: Double {
        let armor = self.baseArmor + Hero.agiArmor * Double(self.baseAgi)
        return armor
    }
    
    var mainAttributes: Int32 {
        switch self.primaryAttr {
        case "str":
            return self.baseStr
        case "agi":
            return self.baseAgi
        case "int":
            return self.baseInt
        default:
            return 0
        }
    }
    
    var mainAttributesGain: Double {
        switch self.primaryAttr {
        case "str":
            return self.gainStr
        case "agi":
            return self.gainAgi
        case "int":
            return self.gainInt
        default:
            return 0.0
        }
    }
    
    // MARK: - functions
    func calculateHPLevel(level: Double) -> Int {
        let totalStr = calculateAttribute(level: level, attr: .str)
        let hp = Int(self.baseHealth + totalStr * Hero.strMaxHP)
        return hp
    }
    
    func calculateManaLevel(level: Double) -> Int {
        let totalInt = calculateAttribute(level: level, attr: .int)
        let hp = Int(self.baseMana + totalInt * Hero.intMaxMP)
        return hp
    }
    
    func calculateHPRegen(level: Double) -> Double {
        let totalStr = calculateAttribute(level: level, attr: .str)
        let regen = self.baseHealthRegen + Double(totalStr) * Hero.strHPRegen
        return regen
    }
    
    func calculateMPRegen(level: Double) -> Double {
        let totalInt = calculateAttribute(level: level, attr: .int)
        let regen = self.baseManaRegen + Double(totalInt) * Hero.intManaRegen
        return regen
    }
    
    func calculateAttribute(level: Double, attr: HeroAttributes) -> Int32 {
        var base: Int32 = 0
        var gain = 0.0
        switch attr {
        case .all:
            base = 0
            gain = 0
        case .str:
            base = baseStr
            gain = gainStr
        case .agi:
            base = baseAgi
            gain = gainAgi
        case .int:
            base = baseInt
            gain = gainInt
        }
        var total = base + Int32((level - 1) * gain)
        total = levelBonusAttribute(base: total, level: level)
        return Int32(total)
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
