//
//  OpenDotaConstantProvider.swift
//  D2A
//
//  Created by Shibo Tong on 1/5/2025.
//

import Foundation

protocol OpenDotaConstantProviding {
    func loadAbilities() async throws -> [ODAbility]
    func loadGameModes() async throws -> [ODGameMode]
    func loadHeroes() async throws -> [ODHero]
    func loadItemIDs() async throws -> [String: String]
}

class OpenDotaConstantProvider: OpenDotaConstantProviding {
    
    static let shared = OpenDotaConstantProvider()
    
    private let fetcher: OpenDotaConstantFetching
    private let processor: OpenDotaConstantProcessor = .shared
    
    init(fetcher: OpenDotaConstantFetching = OpenDotaConstantFetcher()) {
        self.fetcher = fetcher
    }
    
    func loadAbilities() async throws -> [ODAbility] {
        guard let abilityDict = try await fetcher.loadService(service: .abilities, as: [String: ODAbility].self),
              let abilityIDs = try await fetcher.loadService(service: .abilityIDs, as: [String: String].self) else {
            return []
        }
        let scepters = try await fetcher.loadService(service: .aghs, as: [ODScepter].self) ?? []
        let abilities = processor.processAbilities(ability: abilityDict, ids: abilityIDs, scepters: scepters)
        return abilities
    }
    
    func loadGameModes() async throws -> [ODGameMode] {
        guard let gameModesDict = try await fetcher.loadService(service: .gameMode, as: [String: ODGameMode].self) else {
            return []
        }
        return processor.processGameModes(modes: gameModesDict)
    }
    
    func loadHeroes() async throws -> [ODHero] {
        guard let heroDict = try await fetcher.loadService(service: .heroes, as: [String: ODHero].self) else {
            return []
        }
        let abilities = try await fetcher.loadService(service: .heroAbilities, as: [String: ODHeroAbilities].self) ?? [:]
        let lores = try await fetcher.loadService(service: .heroLore, as: [String: String].self) ?? [:]
        return processor.processHeroes(heroes: heroDict, abilities: abilities, lores: lores)
    }
    
    func loadItemIDs() async throws -> [String: String] {
        guard let itemIDs = try await fetcher.loadService(service: .itemIDs, as: [String: String].self) else {
            return [:]
        }
        return itemIDs
    }
    
    func loadScepters() async throws -> [ODScepter] {
        guard let scepters = try await fetcher.loadService(service: .aghs, as: [ODScepter].self) else {
            return []
        }
        return scepters
    }
}
