//
//  PersistanceController+D2AData.swift
//  D2A
//
//  Created by Shibo Tong on 10/11/2024.
//

import Foundation

protocol CoreDataController {
    func insertHeroes(heroes: [HeroCodable]) async throws
    func insertAbilities(abilities: [String: AbilityCodable], idTable: [String: String]) async throws
}

extension PersistenceController: CoreDataController {
    func insertHeroes(heroes: [HeroCodable]) async throws {
        // check hero entity has data
        let privateContext = container.newBackgroundContext()
        
        let heroCounts = try await countEntity(for: Hero.self, context: privateContext)
        if heroCounts == 0 {
            D2ALogger.shared.log("No hero data, do batch insert.", level: .info)
            var heroCount = 0
            try batchInsert(entity: Hero.self, privateContext: privateContext) { object in
                guard let hero = object as? Hero, heroCount < heroes.count else {
                    return true
                }
                
                let heroData = heroes[heroCount]
                hero.updateHero(model: heroData)
                heroCount += 1
                return false
            }
        } else {
            D2ALogger.shared.log("\(heroCounts) hero data already inserted, insert new hero or update existing ones.", level: .info)
            for heroData in heroes {
                let predicate = NSPredicate(format: "%K = %d", #keyPath(Hero.heroID), heroData.heroID)
                let hero: Hero = fetchOne(for: Hero.self, predicate: predicate, context: privateContext) ?? Hero(context: privateContext)
                hero.updateHero(model: heroData)
            }
            try privateContext.save()
        }
    }
    
    func insertAbilities(abilities: [String: AbilityCodable], idTable: [String: String]) async throws {
        let context = container.newBackgroundContext()
        
        let abilityCounts = try await countEntity(for: Ability.self, context: context)
        if abilityCounts == 0 {
            D2ALogger.shared.log("No ability data, batch insert", level: .info)
            var tempAbilityID = 0
            try batchInsert(entity: Ability.self, privateContext: context) { [weak self] object in
                guard let ability = object as? Ability, let (abilityID, name, abilityData) = self?.fetchNextAbility(abilityID: tempAbilityID, abilities: abilities, idTable: idTable) else {
                    return true
                }
                ability.update(abilityID: abilityID, name: name, ability: abilityData)
                tempAbilityID = abilityID + 1
                return false
            }
            D2ALogger.shared.log("Batch insert abilities successfully", level: .info)
        } else {
            D2ALogger.shared.log("\(abilityCounts) ability data already inserted, skipping batch insert", level: .info)
            for (abilityIDString, name) in idTable {
                guard let abilityData = abilities[name], let abilityID = Int(abilityIDString) else { continue }
                let predicate = NSPredicate(format: "%K = %d", #keyPath(Ability.abilityID), abilityID)
                let ability: Ability = fetchOne(for: Ability.self, predicate: predicate, context: context) ?? Ability(context: context)
                ability.update(abilityID: abilityID, name: name, ability: abilityData)
                if ability.hasChanges {
                    D2ALogger.shared.log("ability \(abilityID) has changes", level: .info)
                }
            }
            try context.save()
        }
    }
    
    private func updateSingleAbility(abilityID: Int, name: String, abilityData: AbilityCodable) async throws -> Int? {
        let context = container.newBackgroundContext()
        return try await context.perform { [weak self] in
            let predicate = NSPredicate(format: "%K = %d", #keyPath(Ability.abilityID), abilityID)
            let ability: Ability = self?.fetchOne(for: Ability.self, predicate: predicate, context: context) ?? Ability(context: context)
            ability.update(abilityID: abilityID, name: name, ability: abilityData)
            try context.save()
            return ability.hasChanges ? abilityID : nil
        }
    }
    
    private func fetchNextAbility(abilityID: Int, abilities: [String: AbilityCodable], idTable: [String: String]) -> (abilityID: Int, name: String, ability: AbilityCodable)? {
        // max id
        guard abilityID <= 9999 else { return nil }
        for i in abilityID...9999 {
            guard let name = idTable["\(i)"],
                  let ability = abilities[name] else {
                continue
            }
            return (i, name, ability)
        }
        return nil
    }
}
