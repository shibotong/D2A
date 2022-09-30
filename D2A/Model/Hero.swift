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
        hero.talents = NSSet(array: try heroTalents.map({ return try HeroTalentType.createTalent($0) }))
        
        // data from OpenDota
        hero.abilities = abilities as NSObject
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
        let hp = self.baseHealth + self.baseStr * HeroModel.strMaxHP
        return hp
    }
    var calculateHPRegen: Double {
        let regen = self.baseHealthRegen + Double(self.baseStr) * HeroModel.strHPRegen
        return regen
    }
    
    var calculateMP: Int32 {
        let mp = self.baseMana + self.baseInt * HeroModel.intMaxMP
        return mp
    }
    var calculateMPRegen: Double {
        let regen = self.baseManaRegen + Double(self.baseInt) * HeroModel.intManaRegen
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
        let armor = self.baseArmor + HeroModel.agiArmor * Double(self.baseAgi)
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
        // 17, 19, 21, 22, 23, 24, 26 +2 all attributes
        var totalStr = self.baseStr + Int32((level - 1) * self.gainStr)
        if level >= 17 {
            totalStr += 2
        }
        if level >= 19 {
            totalStr += 2
        }
        if level >= 21 {
            totalStr += 2
        }
        if level >= 22 {
            totalStr += 2
        }
        if level >= 23 {
            totalStr += 2
        }
        if level >= 24 {
            totalStr += 2
        }
        if level >= 26 {
            totalStr += 2
        }
        let hp = Int(self.baseHealth + totalStr * HeroModel.strMaxHP)
        return hp
    }
    
    func calculateManaLevel(level: Double) -> Int {
        var totalInt = self.baseInt + Int32((level - 1) * self.gainInt)
        if level >= 17 {
            totalInt += 2
        }
        if level >= 19 {
            totalInt += 2
        }
        if level >= 21 {
            totalInt += 2
        }
        if level >= 22 {
            totalInt += 2
        }
        if level >= 23 {
            totalInt += 2
        }
        if level >= 24 {
            totalInt += 2
        }
        if level >= 26 {
            totalInt += 2
        }
        let hp = Int(self.baseMana + totalInt * HeroModel.intMaxMP)
        return hp
    }
    
    func calculateHPRegenLevel(level: Double) -> Double {
        let regen = self.baseHealthRegen + Double(self.baseStr) * (level - 1) * HeroModel.strHPRegen
        return regen
    }
}
