//
//  MockOpenDotaConstantProvider.swift
//  D2A
//
//  Created by Shibo Tong on 4/5/2025.
//

class MockOpenDotaConstantProvider: OpenDotaConstantProviding {
    func loadHeroes() async -> [String: ODHero] {
        guard let heroes = loadSampleHero() else {
            return [:]
        }
        return heroes
    }
    
    func loadItemIDs() async -> [String: String] {
        return [:]
    }
    
    func loadAbilities() async -> [ODAbility] {
        return []
    }
    
    func loadAbilitiesForHeroes() async -> [String: ODHeroAbilities] {
        return [:]
    }
    
    func loadSampleHero() -> [String: ODHero]? {
        return [:]
    }
}
