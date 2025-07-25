//
//  OpenDotaConstantProvider.swift
//  D2A
//
//  Created by Shibo Tong on 1/5/2025.
//

import Foundation

protocol OpenDotaConstantProviding {
    func loadAbilities() async -> [ODAbility]
    func loadAbilitiesForHeroes() async -> [String: ODHeroAbilities]
    func loadGameModes() async -> [ODGameMode]
    func loadHeroes() async -> [ODHero]
    func loadItemIDs() async -> [String: String]
    func loadScepters() async -> [ODScepter]
}

class OpenDotaConstantProvider: OpenDotaConstantProviding {
    
    static let shared = OpenDotaConstantProvider()
    
    private let fetcher: OpenDotaConstantFetching
    private let processor: OpenDotaConstantProcessor = .shared
    
    init(fetcher: OpenDotaConstantFetching = OpenDotaConstantFetcher()) {
        self.fetcher = fetcher
    }
    
    func loadAbilities() async -> [ODAbility] {
        guard let abilityDict = await fetcher.loadService(service: .abilities, as: [String: ODAbility].self),
              let abilityIDs = await fetcher.loadService(service: .abilityIDs, as: [String: String].self) else {
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
                logDebug("\(name) has empty dname", category: .opendotaConstant)
                continue
            }
            ability.id = abilityID
            ability.name = name
            abilities.append(ability)
        }
        return abilities
    }
    
    func loadAbilitiesForHeroes() async -> [String: ODHeroAbilities] {
        guard let heroAbilities = await fetcher.loadService(service: .heroAbilities,
                                                            as: [String: ODHeroAbilities].self) else {
            return [:]
        }
        return heroAbilities
    }
    
    func loadGameModes() async -> [ODGameMode] {
        guard let gameModesDict = await fetcher.loadService(service: .gameMode, as: [String: ODGameMode].self) else {
            return []
        }
        
        var gameModes: [ODGameMode] = []
        for (_, mode) in gameModesDict {
            gameModes.append(mode)
        }
        
        return gameModes
    }
    
    func loadHeroes() async -> [ODHero] {
        guard let heroDict = await fetcher.loadService(service: .heroes, as: [String: ODHero].self) else {
            return []
        }
        return processor.processHeroes(heroes: heroDict)
    }
    
    func loadItemIDs() async -> [String: String] {
        guard let itemIDs = await fetcher.loadService(service: .itemIDs, as: [String: String].self) else {
            return [:]
        }
        return itemIDs
    }
    
    func loadScepters() async -> [ODScepter] {
        guard let scepters = await fetcher.loadService(service: .aghs, as: [ODScepter].self) else {
            return []
        }
        return scepters
    }
}
