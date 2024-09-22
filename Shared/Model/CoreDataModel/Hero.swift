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
    
    // MARK: - Static func
    
    static func deleteAllHeroes(context: NSManagedObjectContext) async throws -> Bool {
        let heroes = fetchAllHeroes(viewContext: context)
        let result = try await deleteHero(heroes: heroes, context: context)
        return result
    }
    
    static func deleteHero(heroes: [Hero], context: NSManagedObjectContext) async throws -> Bool {
        return try await context.perform {
            let batchDeleteRequest = NSBatchDeleteRequest(objectIDs: heroes.map(\.objectID))
            batchDeleteRequest.resultType = .resultTypeStatusOnly
            let result = try context.execute(batchDeleteRequest) as! NSBatchDeleteResult
            return result.result as! Bool
        }
    }
    
    /// Create `Hero` with `HeroModel` and `HeroQuery.Data.Constants.Hero` and save into Core Data
    static func save(heroData: HeroCodable,
                     abilityNames: [String],
                     localisation: Localisation? = nil,
                     context: NSManagedObjectContext) {
        let heroID = Double(heroData.id)
        let hero = fetchHero(id: heroID) ?? Hero(context: context)
        // data from Stratz
        setIfNotEqual(entity: hero, path: \.id, value: heroID)
        setIfNotEqual(entity: hero, path: \.displayName, value: heroData.localizedName)
        setIfNotEqual(entity: hero, path: \.name, value: heroData.name)
        
        // data from OpenDota
        setIfNotEqual(entity: hero, path: \.primaryAttr, value: heroData.primaryAttr)
        setIfNotEqual(entity: hero, path: \.attackType, value: heroData.attackType)
        setIfNotEqual(entity: hero, path: \.img, value: heroData.img)
        setIfNotEqual(entity: hero, path: \.icon, value: heroData.icon)
        
        setIfNotEqual(entity: hero, path: \.baseHealth, value: heroData.baseHealth)
        setIfNotEqual(entity: hero, path: \.baseHealthRegen, value: heroData.baseHealthRegen)
        setIfNotEqual(entity: hero, path: \.baseMana, value: heroData.baseMana)
        setIfNotEqual(entity: hero, path: \.baseManaRegen, value: heroData.baseManaRegen)
        setIfNotEqual(entity: hero, path: \.baseArmor, value: heroData.baseArmor)
        setIfNotEqual(entity: hero, path: \.baseMr, value: heroData.baseMr)
        setIfNotEqual(entity: hero, path: \.baseAttackMin, value: heroData.baseAttackMin)
        setIfNotEqual(entity: hero, path: \.baseAttackMax, value: heroData.baseAttackMax)
        
        setIfNotEqual(entity: hero, path: \.baseStr, value: heroData.baseStr)
        setIfNotEqual(entity: hero, path: \.baseAgi, value: heroData.baseAgi)
        setIfNotEqual(entity: hero, path: \.baseInt, value: heroData.baseInt)
        setIfNotEqual(entity: hero, path: \.gainStr, value: heroData.strGain)
        setIfNotEqual(entity: hero, path: \.gainAgi, value: heroData.agiGain)
        setIfNotEqual(entity: hero, path: \.gainInt, value: heroData.intGain)
        
        setIfNotEqual(entity: hero, path: \.complexity, value: Int16(localisation?.stats?.complexity ?? 0))
        
        setIfNotEqual(entity: hero, path: \.attackRange, value: heroData.attackRange)
        setIfNotEqual(entity: hero, path: \.projectileSpeed, value: heroData.projectileSpeed)
        setIfNotEqual(entity: hero, path: \.attackRate, value: heroData.attackRate)
        setIfNotEqual(entity: hero, path: \.moveSpeed, value: heroData.moveSpeed)
        setIfNotEqual(entity: hero, path: \.turnRate, value: heroData.turnRate ?? 0.6)
        
        setIfNotEqual(entity: hero, path: \.visionDaytimeRange, value: Int16(heroData.visionDay))
        setIfNotEqual(entity: hero, path: \.visionNighttimeRange, value: Int16(heroData.visionNight))
        
        let roles = localisation?.roles?.compactMap { $0 } ?? []
        let talents = localisation?.talents?.compactMap { $0 } ?? []
       
        hero.talents = talents.compactMap { talent in
            guard let slot = talent.slot,
                  let abilityIDDouble = talent.abilityId else {
                return nil
            }
            
            return HeroTalent(slot: slot, abilityID: Int(abilityIDDouble))
        }
        
        hero.roles = roles.compactMap { role in
            guard let roleId = role.roleId,
                  let level = role.level else {
                return nil
            }
            return HeroRole(level: Int(level), roleId: roleId.rawValue)
        }
        
        let filteredAbilities = abilityNames.filter { ability in
            let containHidden = ability.contains("hidden")
            let containEmpty = ability.contains("empty")
            return !containHidden && !containEmpty
        }
        hero.updateAbilities(filteredAbilities, context: context)
        if let localisation {
            hero.updateLocalisation(localisationData: localisation)
        }
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
        if !abilitiesToRemove.isEmpty {
            removeFromAbilities(NSSet(array: abilitiesToRemove))
        }
        
        for abilityName in abilityNames {
            if savedAbilities.contains(where: { $0.name == abilityName }) {
                continue
            }
            newAbilities.append(abilityName)
        }
        guard !newAbilities.isEmpty else { return }
        addingAbilitiesToHero(names: newAbilities, context: context)
    }
    
    func updateLocalisation(localisationData: Localisation) {
        let localisation = HeroLocalisation(language: languageCode.rawValue,
                                            displayName: localisationData.language?.displayName ?? "",
                                            lore: localisationData.language?.lore,
                                            hype: localisationData.language?.hype)
        if localisations == nil {
            localisations = [localisation]
        } else {
            localisations?.removeAll(where: { $0.language == languageCode.rawValue })
            localisations?.append(localisation)
        }
    }
    
    private func addingAbilitiesToHero(names: [String], context: NSManagedObjectContext) {
        let abilities = Ability.fetchAbilities(names: names, viewContext: context)
        addToAbilities(NSSet(array: abilities))
    }
    
    /// Fetch `Hero` with `id` in CoreData
    static func fetchHero(id: Double, viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> Hero? {
        let predicate = NSPredicate(format: "id == %f", id)
        return runQuery(viewContext: viewContext, predicate: predicate).first
    }
    
    static func fetchAllHeroes(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext, sortDescriptors: [NSSortDescriptor] = []) -> [Hero] {
        runQuery(viewContext: viewContext, sortDescriptors: sortDescriptors)
    }
    
    static func runQuery(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext,
                         predicate: NSPredicate? = nil,
                         sortDescriptors: [NSSortDescriptor] = []) -> [Hero] {
        let fetchRequest = Hero.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
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
        currentLocalisation?.displayName ?? "no_name"
    }
    
    var currentLocalisation: HeroLocalisation? {
        if let localisation = localisations?.first(where: { localisation in
            localisation.language == languageCode.rawValue
        }) {
            return localisation
        } else {
            return localisations?.first
        }
    }
    
    var allAbilities: [Ability] {
        abilities?.allObjects as? [Ability] ?? []
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
    
    func fetchRole(role: String) -> HeroRole {
        let roleName = role.uppercased()
        if let searchedRole = roles?.first(where: { $0.roleId == roleName }) {
            return searchedRole
        } else {
            return HeroRole(level: 0, roleId: role)
        }
    }
}
