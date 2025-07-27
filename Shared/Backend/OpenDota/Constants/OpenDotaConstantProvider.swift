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
        let scepters = await fetcher.loadService(service: .aghs, as: [ODScepter].self) ?? []
        let abilities = processor.processAbilities(ability: abilityDict, ids: abilityIDs, scepters: scepters)
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
        return processor.processGameModes(modes: gameModesDict)
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
