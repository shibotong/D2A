//
//  OpenDotaConstantProcessor.swift
//  D2A
//
//  Created by Shibo Tong on 23/7/2025.
//

class OpenDotaConstantProcessor {
    
    static let shared = OpenDotaConstantProcessor()
    
    func processHeroes(heroes: [String: ODHero]) -> [ODHero] {
        var heroesArray: [ODHero] = []
        for (_, value) in heroes {
            heroesArray.append(value)
        }
        return heroesArray
    }
    
    func processGameModes(modes: [String: ODGameMode]) -> [ODGameMode] {
        var gameModes: [ODGameMode] = []
        for (_, mode) in modes {
            gameModes.append(mode)
        }
        return gameModes
    }
    
    func processAbilities(ability: [String: ODAbility], ids: [String: String]) -> [ODAbility] {
        var abilities: [ODAbility] = []
        
        for (abilityIDString, name) in ids {
            guard var ability = ability[name] else {
                logDebug("\(name) cannot be found", category: .opendotaConstant)
                continue
            }
            guard let abilityID = Int(abilityIDString) else {
                logWarn("\(abilityIDString) abilityID is not a number", category: .opendotaConstant)
                continue
            }
            guard let dname = ability.dname, !dname.isEmpty else {
                logDebug("\(name) has empty dname", category: .opendotaConstant)
                continue
            }
            ability.id = abilityID
            ability.name = name
            abilities.append(ability)
        }
        return abilities
    }
}
