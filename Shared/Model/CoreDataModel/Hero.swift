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
    
    typealias Localisation = LocaliseQuery.Data.Constants.Hero
    typealias StratzRole = LocaliseQuery.Data.Constants.Hero.Role
    typealias StratzTalent = LocaliseQuery.Data.Constants.Hero.Talent
    
    // MARK: - Error
    enum CoreDataError: Error {
        case decodingError
    }
    
    static func save(heroData: HeroCodable, 
                     abilityNames: [String],
                     localisation: Localisation? = nil,
                     context: NSManagedObjectContext) throws {
        let heroID = Double(heroData.id)
        let hero = fetchHero(id: heroID) ?? Hero(context: context)
        // data from Stratz
        hero.id = heroID
        hero.displayName = heroData.localizedName
        hero.name = heroData.name
        
        // data from OpenDota
        hero.primaryAttr = heroData.primaryAttr
        hero.attackType = heroData.attackType
        hero.img = heroData.img
        hero.icon = heroData.icon
        
        hero.baseHealth = heroData.baseHealth
        hero.baseHealthRegen = heroData.baseHealthRegen
        hero.baseMana = heroData.baseMana
        hero.baseManaRegen = heroData.baseManaRegen
        hero.baseArmor = heroData.baseArmor
        hero.baseMr = heroData.baseMr
        hero.baseAttackMin = heroData.baseAttackMin
        hero.baseAttackMax = heroData.baseAttackMax
        
        hero.baseStr = heroData.baseStr
        hero.baseAgi = heroData.baseAgi
        hero.baseInt = heroData.baseInt
        hero.gainStr = heroData.strGain
        hero.gainAgi = heroData.agiGain
        hero.gainInt = heroData.intGain
        
        hero.complexity = Int16(localisation?.stats?.complexity ?? 0)
        
        hero.attackRange = heroData.attackRange
        hero.projectileSpeed = heroData.projectileSpeed
        hero.attackRate = heroData.attackRate
        hero.moveSpeed = heroData.moveSpeed
        hero.turnRate = heroData.turnRate ?? 0.6
        
        hero.visionDaytimeRange = Int16(heroData.visionDay)
        hero.visionNighttimeRange = Int16(heroData.visionNight)
        
        let roles = localisation?.roles?.compactMap { $0 } ?? []
        let talents = localisation?.talents?.compactMap { $0 } ?? []
        
        hero.updateRoles(roles, context: context)
        hero.updateTalents(talents, context: context)
        
        let filteredAbilities = abilityNames.filter { ability in
            let containHidden = ability.contains("hidden")
            let containEmpty = ability.contains("empty")
            return !containHidden && !containEmpty
        }
        hero.updateAbilities(filteredAbilities, context: context)
        
        try context.save()
    }
    
    // MARK: - Static func
    /// Create `Hero` with `HeroModel` and `HeroQuery.Data.Constants.Hero` and save into Core Data
    static func createHero(_ queryHero: LocaliseQuery.Data.Constants.Hero? = nil, model: HeroCodable) throws -> Hero {
        let viewContext = PersistenceController.shared.container.viewContext
        
        let heroID = Double(model.id)
        let hero = fetchHero(id: heroID) ?? Hero(context: viewContext)
        // data from Stratz
        hero.id = heroID
        hero.displayName = model.localizedName
        hero.name = model.name
        
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
        
        if let query = queryHero,
           let heroTalents = query.talents,
           let heroRoles = query.roles,
           let heroStats = query.stats {
            hero.complexity = Int16(heroStats.complexity ?? 0)
            hero.visionDaytimeRange = Int16(heroStats.visionDaytimeRange ?? 1800)
            hero.visionNighttimeRange = Int16(heroStats.visionNighttimeRange ?? 800)
            hero.roles = NSSet(array: try heroRoles.map({ return try Role.createRole($0) }))
            hero.talents = NSSet(array: try heroTalents.map({ return try Talent.createTalent($0) }))
        }

        try viewContext.save()
        return hero
    }
    
    private func updateAbilities(_ abilityNames: [String], context: NSManagedObjectContext) {
        guard let savedAbilities = abilities?.allObjects as? [Ability] else {
            addingAbilitiesToHero(names: abilityNames, context: context)
            return
        }
        
        var newAbilities: [String] = []
        var abilitiesToRemove: [Ability] = []
        
        for ability in savedAbilities {
            guard let abilityName = ability.name,
                  !abilityNames.contains(abilityName) else {
                continue
            }
            abilitiesToRemove.append(ability)
        }
        
        Logger.shared.log(level: .verbose, message: "\(abilitiesToRemove.map { $0.name }) don't exist for hero \(name ?? "ERROR") anymore")
        removeFromAbilities(NSSet(array: abilitiesToRemove))
        
        for abilityName in abilityNames {
            if savedAbilities.contains(where: { $0.name == abilityName }) {
                continue
            }
            newAbilities.append(abilityName)
        }
        
        addingAbilitiesToHero(names: newAbilities, context: context)
    }
    
    private func addingAbilitiesToHero(names: [String], context: NSManagedObjectContext) {
        let abilities = Ability.fetchAbilities(names: names, viewContext: context)
        addToAbilities(NSSet(array: abilities))
        Logger.shared.log(level: .verbose, message: "Save abilities to hero \(id), \(abilities.map { $0.name })")
    }
    
    private func updateRoles(_ roles: [StratzRole],
                             context: NSManagedObjectContext) {
        roles.forEach { updateRole($0, context: context) }
    }
    
    private func updateRole(_ role: StratzRole, context: NSManagedObjectContext) {
        guard let roleID = role.roleId?.rawValue,
              let level = role.level else {
            return
        }
        
        if let roles = roles?.allObjects as? [Role],
           let savedRole = roles.first(where: { $0.roleId == roleID }) {
            savedRole.level = level
        } else {
            let newRole = Role(context: context)
            newRole.roleId = roleID
            newRole.level = level
            addToRoles(newRole)
        }
    }
    
    private func updateTalents(_ talents: [StratzTalent], context: NSManagedObjectContext) {
        talents.forEach { updateTalent($0, context: context) }
    }
    
    private func updateTalent(_ talent: StratzTalent, context: NSManagedObjectContext) {
        guard let talentSlot = talent.slot,
        let abilityID = talent.abilityId,
        let ability = Ability.fetchAbility(id: Int(abilityID), viewContext: context) else {
            return
        }
        
        if let talents = talents?.allObjects as? [Talent],
           let savedTalent = talents.first(where: { $0.slot == talentSlot }) {
            savedTalent.ability = ability
        } else {
            let newTalent = Talent(context: context)
            newTalent.slot = Int16(talentSlot)
            newTalent.ability = ability
            addToTalents(newTalent)
        }
    }
    
    /// Fetch `Hero` with `id` in CoreData
    static func fetchHero(id: Double, viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> Hero? {
        let predicate = NSPredicate(format: "id == %f", id)
        return runQuery(viewContext: viewContext, predicate: predicate).first
    }
    
    static func fetchAllHeroes(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> [Hero] {
        runQuery(viewContext: viewContext)
    }
    
    static func runQuery(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext,
                         predicate: NSPredicate? = nil) -> [Hero] {
        let fetchRequest = Hero.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results
        } catch {
            print(error.localizedDescription)
            return []
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
    
    private func calculateHPLevel(level: Double) -> Int {
        let totalStr = calculateAttribute(level: level, attr: .str)
        let hp = Int(baseHealth + totalStr * Hero.strMaxHP)
        return hp
    }
    
    private func calculateManaLevel(level: Double) -> Int {
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
}
