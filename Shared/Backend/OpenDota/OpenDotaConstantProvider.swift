//
//  OpenDotaConstantProvider.swift
//  D2A
//
//  Created by Shibo Tong on 1/5/2025.
//

import Foundation
protocol OpenDotaConstantProviding {
    func loadHeroes() async -> [String: ODHero]
    func loadItemIDs() async -> [String: String]
    func loadAbilities() async -> [ODAbility]
    func loadAbilitiesForHeroes() async -> [String: [Int]]
}

class OpenDotaConstantProvider: OpenDotaConstantProviding {
    
    static let shared = OpenDotaConstantProvider()
    
    private let maxHeroID = 150
    
    func loadHeroes() async -> [String: ODHero] {
        let heroURL = OpenDotaConstantService.heroes.serviceURL
        do {
            let heroes = try await D2ANetwork.default.dataTask(heroURL, as: [String: ODHero].self)

            return heroes
        } catch {
            logWarn("Loading heroes from OpenDotaConstantController failed: \(error.localizedDescription)", category: .opendotaConstant)
            return [:]
        }
    }
    
    func loadAbilities() async -> [ODAbility] {
        let abilityURL = OpenDotaConstantService.abilities.serviceURL
        let abilityIDURL = OpenDotaConstantService.abilityIDs.serviceURL
        
        do {
            let abilityDict = try await D2ANetwork.default.dataTask(abilityURL, as: [String: ODAbility].self)
            let abilityIDs = try await D2ANetwork.default.dataTask(abilityIDURL, as: [String: String].self)
            
            var abilities: [ODAbility] = []
            
            for (abilityIDString, name) in abilityIDs {
                guard var ability = abilityDict[name] else {
                    logDebug("\(name) cannot be found", category: .opendotaConstant)
                    continue
                }
                guard let abilityID = Int(abilityIDString) else {
                    logWarn("\(abilityIDString) abilityID is not a number", category: .opendotaConstant)
                    continue
                }
                guard let dname = ability.dname, !dname.isEmpty else {
                    continue
                }
                ability.id = abilityID
                ability.name = name
                abilities.append(ability)
            }
            return abilities
        } catch {
            logWarn("Loading abilities from OpenDotaConstantController failed: \(error.localizedDescription)", category: .opendotaConstant)
            return []
        }
    }
    
    func loadItemIDs() async -> [String: String] {
        let itemIDURL = OpenDotaConstantService.itemIDs.serviceURL
        do {
            let itemIDs = try await D2ANetwork.default.dataTask(itemIDURL, as: [String: String].self)
            return itemIDs
        } catch {
            logWarn("Loading itemIDs from OpenDotaConstantController failed: \(error.localizedDescription)", category: .opendotaConstant)
            return [:]
        }
    }

}
