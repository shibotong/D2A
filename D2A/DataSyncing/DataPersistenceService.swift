//
//  DataPersistenceService.swift
//  D2A
//
//  Created by Shibo Tong on 20/4/2026.
//

import CoreData
import Logging
import OpenDota
import Stratz

class DataPersistenceService {
    
    static let shared = DataPersistenceService()
    
    private let logger: Logger
    
    init(logger: Logger = D2ALogger.syncing) {
        self.logger = logger
    }
    
    func sortAbilities(abilityIDs: [String: String], abilities: [String: ODAbility]) -> [AbilityRecipe] {
        var results: [AbilityRecipe] = []
        for (abilityIDString, name) in abilityIDs {
            guard let ability = abilities[name] else {
                logger.trace("Not able to find abiilty from data: \(name)")
                continue
            }
            var abilityIDString = abilityIDString
            if abilityIDString == "3060,1617" {
                abilityIDString = "1617"
            }
            guard let abilityID = Int(abilityIDString) else {
                logger.error("Ability ID is not an integer: \(abilityIDString)")
                continue
            }
            results.append(AbilityRecipe(abilityID: abilityID, name: name, data: ability))
        }
        return results
    }
    
    func sortHeroes(heroJSON: [String: ODHero], abilitiesJSON: [String: ODHeroAbility], heroAdditionalDatas: [SKHeroAdditional]) -> [HeroRecipe] {
        var heroes: [HeroRecipe] = []
        for heroAdditionalData in heroAdditionalDatas {
            guard let heroData = heroJSON["\(heroAdditionalData.heroID)"], let abilities = abilitiesJSON[heroAdditionalData.name] else {
                logger.warning("hero is not valid")
                continue
            }
            heroes.append(HeroRecipe(heroID: heroAdditionalData.heroID, data: heroData, abilities: abilities, additionalData: heroAdditionalData))
        }
        return heroes
    }
    
    func fetch(heroID: Int, context: NSManagedObjectContext) throws -> Hero? {
        let fetchHero = Hero.fetchRequest()
        fetchHero.predicate = NSPredicate(format: "id == %f", Double(heroID))
        
        let results = try context.fetch(fetchHero)
        return results.first
    }
    
    func save(hero receipe: HeroRecipe, in context: NSManagedObjectContext) throws {
        try save(heroID: receipe.heroID, data: receipe.data, abilities: receipe.abilities, additional: receipe.additionalData, in: context)
    }
        
    private func save(heroID: Int, data: ODHero, abilities: ODHeroAbility, additional: SKHeroAdditional, in context: NSManagedObjectContext) throws {
        let hero = try fetch(heroID: heroID, context: context) ?? Hero(context: context)
        
        setIfNotEqual(entity: hero, path: \.id, value: Double(heroID))
        setIfNotEqual(entity: hero, path: \.name, value: data.name)
        setIfNotEqual(entity: hero, path: \.primaryAttr, value: data.primaryAttr)
        setIfNotEqual(entity: hero, path: \.attackType, value: data.attackType)
        setIfNotEqual(entity: hero, path: \.displayName, value: data.localizedName)
        setIfNotEqual(entity: hero, path: \.baseHealth, value: Int32(data.baseHealth))
        setIfNotEqual(entity: hero, path: \.baseHealthRegen, value: data.baseHealthRegen)
        setIfNotEqual(entity: hero, path: \.baseMana, value: Int32(data.baseMana))
        setIfNotEqual(entity: hero, path: \.baseManaRegen, value: data.baseManaRegen)
        setIfNotEqual(entity: hero, path: \.baseArmor, value: Double(data.baseArmor))
        setIfNotEqual(entity: hero, path: \.baseMr, value: Int32(data.baseMr))
        setIfNotEqual(entity: hero, path: \.baseAttackMin, value: Int32(data.baseAttackMin))
        setIfNotEqual(entity: hero, path: \.baseAttackMax, value: Int32(data.baseAttackMax))
        setIfNotEqual(entity: hero, path: \.baseStr, value: Int32(data.baseStr))
        setIfNotEqual(entity: hero, path: \.baseAgi, value: Int32(data.baseAgi))
        setIfNotEqual(entity: hero, path: \.baseInt, value: Int32(data.baseInt))
        setIfNotEqual(entity: hero, path: \.gainStr, value: data.strGain)
        setIfNotEqual(entity: hero, path: \.gainAgi, value: data.agiGain)
        setIfNotEqual(entity: hero, path: \.gainInt, value: data.intGain)
        setIfNotEqual(entity: hero, path: \.attackRange, value: Int32(data.attackRange))
        setIfNotEqual(entity: hero, path: \.projectileSpeed, value: Int32(data.projectileSpeed))
        setIfNotEqual(entity: hero, path: \.attackRate, value: data.attackRate)
        setIfNotEqual(entity: hero, path: \.moveSpeed, value: Int32(data.moveSpeed))
        setIfNotEqual(entity: hero, path: \.turnRate, value: data.turnRate)
        setIfNotEqual(entity: hero, path: \.visionDaytimeRange, value: Double(data.dayVision))
        setIfNotEqual(entity: hero, path: \.visionNighttimeRange, value: Double(data.nightVision))
        
        // addtional data
        setIfNotEqual(entity: hero, path: \.complexity, value: Int16(additional.complexity))
        setIfNotEqual(entity: hero, path: \.roleCarry, value: Int16(findRole(role: .carry, roles: additional.roles)))
        setIfNotEqual(entity: hero, path: \.roleSupport, value: Int16(findRole(role: .support, roles: additional.roles)))
        setIfNotEqual(entity: hero, path: \.roleNuker, value: Int16(findRole(role: .nuker, roles: additional.roles)))
        setIfNotEqual(entity: hero, path: \.roleDisabler, value: Int16(findRole(role: .disabler, roles: additional.roles)))
        setIfNotEqual(entity: hero, path: \.roleJungler, value: Int16(findRole(role: .jungler, roles: additional.roles)))
        setIfNotEqual(entity: hero, path: \.roleDurable, value: Int16(findRole(role: .durable, roles: additional.roles)))
        setIfNotEqual(entity: hero, path: \.roleEscape, value: Int16(findRole(role: .escape, roles: additional.roles)))
        setIfNotEqual(entity: hero, path: \.rolePusher, value: Int16(findRole(role: .pusher, roles: additional.roles)))
        setIfNotEqual(entity: hero, path: \.roleInitiator, value: Int16(findRole(role: .initiator, roles: additional.roles)))
        
        if let abilities = try? fetch(abilities: abilities.abilities, context: context, ordered: true) {
            hero.abilities = NSOrderedSet(array: abilities)
        }
        
        // abilities
        let talents = abilities.talents
        for (index, talent) in talents.enumerated() {
            let abilityName = talent.name
            let ability = try fetch(ability: abilityName, context: context)
            switch index {
            case 0:
                setIfNotEqual(entity: hero, path: \.talent1right, value: ability)
            case 1:
                setIfNotEqual(entity: hero, path: \.talent1left, value: ability)
            case 2:
                setIfNotEqual(entity: hero, path: \.talent2right, value: ability)
            case 3:
                setIfNotEqual(entity: hero, path: \.talent2left, value: ability)
            case 4:
                setIfNotEqual(entity: hero, path: \.talent3right, value: ability)
            case 5:
                setIfNotEqual(entity: hero, path: \.talent3left, value: ability)
            case 6:
                setIfNotEqual(entity: hero, path: \.talent4right, value: ability)
            case 7:
                setIfNotEqual(entity: hero, path: \.talent4left, value: ability)
            default:
                continue
            }
        }
    }
    
    private func findRole(role: RoleEnum, roles: [SKHeroAdditional.Role]) -> Int {
        guard let role = roles.first(where: { $0.roleId.lowercased() == role.rawValue }) else {
            return 0
        }
        return role.level
    }
    
    func fetchHeroLocalization(id: Int, language: DataLanguageEnum, context: NSManagedObjectContext) throws -> HeroTranslation? {
        return try fetch(heroID: id, language: language, context: context)
    }
    
    func fetch(heroID: Int, language: DataLanguageEnum, context: NSManagedObjectContext) throws -> HeroTranslation? {
        let fetchRequest = HeroTranslation.fetchRequest()
        let predicate = NSPredicate(format: "heroID = %d AND language = %@", heroID, language.rawValue)
        fetchRequest.predicate = predicate
        
        let results = try context.fetch(fetchRequest)
        return results.first
    }
    
    func saveHeroLocalization(localization: SKHero, language: DataLanguageEnum, in context: NSManagedObjectContext) throws {
        try save(hero: localization, language: language, in: context)
    }
        
    func save(hero localization: SKHero, language: DataLanguageEnum, in context: NSManagedObjectContext) throws {
        guard let rootHero = try fetch(heroID: localization.id, context: context) else {
            throw PersistenceError.heroNotFound(localization.id)
        }
        var translation: HeroTranslation
        if let savedTranslation = try fetchHeroLocalization(id: localization.id, language: language, context: context) {
            translation = savedTranslation
        } else {
            translation = HeroTranslation(context: context)
            translation.hero = rootHero
        }
        setIfNotEqual(entity: translation, path: \.language, value: language.rawValue)
        setIfNotEqual(entity: translation, path: \.heroID, value: Int16(localization.id))
        setIfNotEqual(entity: translation, path: \.displayName, value: localization.displayName)
        setIfNotEqual(entity: translation, path: \.lore, value: localization.lore)
        setIfNotEqual(entity: translation, path: \.hype, value: localization.hype)
    }
    
    // MARK: Ability
    
    func fetch(abilityID: Int, context: NSManagedObjectContext) throws -> Ability? {
        let fetchRequest = Ability.fetchRequest()
        let predicate = NSPredicate(format: "abilityID = %d", abilityID)
        fetchRequest.predicate = predicate
        return try context.fetch(fetchRequest).first
    }
    
    func fetch(ability name: String, context: NSManagedObjectContext) throws -> Ability? {
        let fetchRequest = Ability.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = predicate
        return try context.fetch(fetchRequest).first
    }
    
    func fetch(abilities names: [String], context: NSManagedObjectContext, ordered: Bool = false) throws -> [Ability] {
        let fetchRequest = Ability.fetchRequest()
        let predicate = NSPredicate(format: "%K IN %@", #keyPath(Ability.name), names)
        
        fetchRequest.predicate = predicate
        if ordered {
            let results = try context.fetch(fetchRequest)
            return results.sorted { left, right in
                guard let leftString = left.name, let rightString = right.name else {
                    return true
                }
                guard let leftOrder = names.firstIndex(where: { $0 == leftString }), let rightOrder = names.firstIndex(where: { $0 == rightString }) else {
                    return true
                }
                return leftOrder <= rightOrder
            }
        }
        return try context.fetch(fetchRequest)
    }
    
    func save(abilityID: Int, name: String, data: ODAbility, in context: NSManagedObjectContext) throws {
        let ability = try fetch(abilityID: abilityID, context: context) ?? Ability(context: context)
        setIfNotEqual(entity: ability, path: \.name, value: name)
        setIfNotEqual(entity: ability, path: \.abilityID, value: Int16(abilityID))
        setIfNotEqual(entity: ability, path: \.behavior, value: data.behavior?.joined(separator: " / "))
        setIfNotEqual(entity: ability, path: \.bkbPierce, value: data.bkbpierce?.joined(separator: " / "))
        setIfNotEqual(entity: ability, path: \.coolDown, value: data.cd?.joined(separator: " / "))
        setIfNotEqual(entity: ability, path: \.damageType, value: data.dmgType?.joined(separator: " / "))
        setIfNotEqual(entity: ability, path: \.desc, value: data.desc)
        setIfNotEqual(entity: ability, path: \.dispellable, value: data.dispellable)
        setIfNotEqual(entity: ability, path: \.dname, value: data.dname)
        setIfNotEqual(entity: ability, path: \.lore, value: data.lore)
        setIfNotEqual(entity: ability, path: \.manaCost, value: data.mc?.joined(separator: " / "))
        setIfNotEqual(entity: ability, path: \.targetTeam, value: data.targetTeam?.joined(separator: " / "))
        setIfNotEqual(entity: ability, path: \.targetType, value: data.targetType?.joined(separator: " / "))
    }
    
    private func setStringOrArray(entity: Ability, path: ReferenceWritableKeyPath<Ability, String?>, data: [String: Any], key: String) {
        guard let value = fetchStringOrArray(data: data, key: key) else {
            return
        }
        setIfNotEqual(entity: entity, path: path, value: value)
    }
    
    private func fetchStringOrArray(data: [String: Any], key: String) -> String? {
        guard let value = data[key] else {
            return nil
        }
        
        if let result = value as? String {
            return result
        }
        
        if let array = value as? [String] {
            return array.joined(separator: " / ")
        }
        
        return nil
    }
    
    func fetch(abilityID: Int, language: DataLanguageEnum, context: NSManagedObjectContext) throws -> AbilityTranslation? {
        let fetchRequest = AbilityTranslation.fetchRequest()
        let predicate = NSPredicate(format: "abilityID = %d AND language = %@", abilityID, language.rawValue)
        fetchRequest.predicate = predicate

        let results = try context.fetch(fetchRequest)
        return results.first
    }
    
    func fetch(ability name: String, language: DataLanguageEnum, context: NSManagedObjectContext) throws -> AbilityTranslation? {
        let fetchRequest = AbilityTranslation.fetchRequest()
        let predicate = NSPredicate(format: "name = %@ AND language = %@", name, language.rawValue)
        fetchRequest.predicate = predicate

        let results = try context.fetch(fetchRequest)
        return results.first
    }
    
    func save(ability: SKAbility, language: DataLanguageEnum, in context: NSManagedObjectContext) throws {
        guard let rootAbility = try fetch(abilityID: ability.id, context: context) else {
            throw PersistenceError.abilityNotFound(ability.id)
        }
        var translation: AbilityTranslation
        if let savedTranslation = try fetch(abilityID: ability.id, language: language, context: context) {
            translation = savedTranslation
        } else {
            translation = AbilityTranslation(context: context)
            translation.ability = rootAbility
        }
        setIfNotEqual(entity: translation, path: \.language, value: language.rawValue)
        setIfNotEqual(entity: translation, path: \.abilityID, value: Int16(ability.id))
        setIfNotEqual(entity: translation, path: \.name, value: ability.name)
        setIfNotEqual(entity: translation, path: \.aghanimDescription, value: ability.aghanimDescription)
        setIfNotEqual(entity: translation, path: \.displayName, value: ability.displayName)
        setIfNotEqual(entity: translation, path: \.desc, value: ability.description.joined(separator: "\n"))
        setIfNotEqual(entity: translation, path: \.lore, value: ability.lore)
        setIfNotEqual(entity: translation, path: \.shardDescription, value: ability.shardDescription)
        setIfNotEqual(entity: translation, path: \.attributes, value: ability.attributes?.compactMap({ $0 }))
    }
}
