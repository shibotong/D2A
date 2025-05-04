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
    func loadAbilitiesForHeroes() async -> [String: ODHeroAbilities]
}

class OpenDotaConstantProvider: OpenDotaConstantProviding {
    
    static let shared = OpenDotaConstantProvider()
    
    private let maxHeroID = 150
    
    func loadHeroes() async -> [String: ODHero] {
        guard let heroDict = await loadOpenDotaConstantService(service: .heroes, type: [String: ODHero].self) else {
            return [:]
        }
        return heroDict
    }
    
    func loadAbilities() async -> [ODAbility] {
        guard let abilityDict = await loadOpenDotaConstantService(service: .abilities, type: [String: ODAbility].self),
              let abilityIDs = await loadOpenDotaConstantService(service: .abilityIDs, type: [String: String].self) else {
            return []
        }
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
    }
    
    func loadItemIDs() async -> [String: String] {
        guard let itemIDs = await loadOpenDotaConstantService(service: .itemIDs, type: [String: String].self) else {
            return [:]
        }
        return itemIDs
    }
    
    func loadAbilitiesForHeroes() async -> [String: ODHeroAbilities] {
        guard let heroAbilities = await loadOpenDotaConstantService(service: .heroAbilities, type: [String: ODHeroAbilities].self) else {
            return [:]
        }
        return heroAbilities
    }
    
    private func loadOpenDotaConstantService<T: Decodable>(service: OpenDotaConstantService, type: T.Type) async -> T? {
        let url = service.serviceURL
        do {
            let data = try await D2ANetwork.default.dataTask(url, as: T.self)
            return data
        } catch {
            logWarn("Loading \(service) from OpenDota failed: \(error)", category: .opendotaConstant)
            return nil
        }
    }

}
