//
//  DataPersistenceService.swift
//  D2A
//
//  Created by Shibo Tong on 20/4/2026.
//

import CoreData

class DataPersistenceService {
    
    static let shared = DataPersistenceService()
    
    func fetch(heroID: Int, context: NSManagedObjectContext) throws -> Hero? {
        let fetchHero = Hero.fetchRequest()
        fetchHero.predicate = NSPredicate(format: "id == %f", Double(heroID))
        
        let results = try context.fetch(fetchHero)
        return results.first
    }
    
    func save(hero receipe: HeroRecipe, in context: NSManagedObjectContext, logger: DataSyncingLogger?) throws {
        try save(heroID: receipe.heroID, data: receipe.data, abilities: receipe.abilities, additional: receipe.additionalData, in: context, logger: logger)
    }
        
    private func save(heroID: Int, data: [String: Any], abilities: [String: Any], additional: SKHeroAdditional, in context: NSManagedObjectContext, logger: DataSyncingLogger?) throws {
        let hero = try fetch(heroID: heroID, context: context) ?? Hero(context: context)
        
        var closure: ((String) -> ())?
        if let logger {
            closure = { key in
                Task {
                    await logger.addError(type: .hero, error: .dataType, key: key)
                }
            }
        }
        
        setIfNotEqual(entity: hero, path: \.id, value: Double(heroID))
        setIfExist(entity: hero, path: \.name, data: data, key: "name", errorCompletion: closure)
        setIfExist(entity: hero, path: \.primaryAttr, data: data, key: "primary_attr", errorCompletion: closure)
        setIfExist(entity: hero, path: \.attackType, data: data, key: "attack_type", errorCompletion: closure)
        setIfExist(entity: hero, path: \.displayName, data: data, key: "localized_name", errorCompletion: closure)
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
        
        if let abilityNames = abilities["abilities"] as? [String], let abilities = try? fetch(abilities: abilityNames, context: context, ordered: true) {
            hero.abilities = NSOrderedSet(array: abilities)
        }
        
        // abilities
        if let talents = abilities["talents"] as? [[String: Any]] {
            for (index, talent) in talents.enumerated() {
                guard let abilityName = talent["name"] as? String else {
                    continue
                }
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
    
    func save(abilityID: Int, name: String, data: [String: Any], in context: NSManagedObjectContext, syncingLogger: DataSyncingLogger? = nil) throws {
        let ability = try fetch(abilityID: abilityID, context: context) ?? Ability(context: context)
        setIfNotEqual(entity: ability, path: \.name, value: name)
        setIfNotEqual(entity: ability, path: \.abilityID, value: Int16(abilityID))
        setStringOrArray(entity: ability, path: \.behavior, data: data, key: "behavior", syncingLogger: syncingLogger)
        setStringOrArray(entity: ability, path: \.bkbPierce, data: data, key: "behavior", syncingLogger: syncingLogger)
        setStringOrArray(entity: ability, path: \.coolDown, data: data, key: "cd", syncingLogger: syncingLogger)
        setStringOrArray(entity: ability, path: \.damageType, data: data, key: "dmg_type", syncingLogger: syncingLogger)
        setStringOrArray(entity: ability, path: \.damageType, data: data, key: "dmg_type", syncingLogger: syncingLogger)
        setIfExist(entity: ability, path: \.desc, data: data, key: "desc")
        setIfExist(entity: ability, path: \.dispellable, data: data, key: "dispellable")
        setIfExist(entity: ability, path: \.dname, data: data, key: "dname")
        setIfExist(entity: ability, path: \.lore, data: data, key: "lore")
        setStringOrArray(entity: ability, path: \.manaCost, data: data, key: "mc", syncingLogger: syncingLogger)
        setStringOrArray(entity: ability, path: \.targetTeam, data: data, key: "target_team", syncingLogger: syncingLogger)
        setStringOrArray(entity: ability, path: \.targetType, data: data, key: "target_type", syncingLogger: syncingLogger)
    }
    
    private func setStringOrArray(entity: Ability, path: ReferenceWritableKeyPath<Ability, String?>, data: [String: Any], key: String, syncingLogger: DataSyncingLogger? = nil) {
        guard let value = fetchStringOrArray(data: data, key: key, logger: syncingLogger) else {
            return
        }
        setIfNotEqual(entity: entity, path: path, value: value)
    }
    
    private func fetchStringOrArray(data: [String: Any], key: String, logger: DataSyncingLogger? = nil) -> String? {
        guard let value = data[key] else {
            return nil
        }
        
        if let result = value as? String {
            return result
        }
        
        if let array = value as? [String] {
            return array.joined(separator: " / ")
        }
        
        Task {
            await logger?.addError(type: .ability, error: .dataType, key: key)
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
