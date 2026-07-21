//
//  MockOpenDotaConstantFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 31/5/2026.
//

import Foundation
import OpenDota

public struct MockOpenDotaFetcher: OpenDotaFetching {
    
    let fileReader: FileReader = .shared
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    public init() { }
    
    public func abilities() async throws -> [String : OpenDota.ODAbility] {
        let data = try fileReader.readFile("abilities")
        return try decoder.decode([String: ODAbility].self, from: data)
    }
    
    public func abilityIDs() async throws -> [String : String] {
        let data = try fileReader.readFile("ability_ids")
        return try decoder.decode([String: String].self, from: data)
    }
    
    public func heroes() async throws -> [String : OpenDota.ODHero] {
        let data = try fileReader.readFile("heroes")
        return try decoder.decode([String: ODHero].self, from: data)
    }
    
    public func heroAbilities() async throws -> [String : OpenDota.ODHeroAbility] {
        let data = try fileReader.readFile("hero_abilities")
        return try decoder.decode([String: ODHeroAbility].self, from: data)
    }
    
    public func match(id: String) async throws -> ODMatch {
        let data = try fileReader.readFile("match_\(id)")
        return try decoder.decode(ODMatch.self, from: data)
    }
    
    public func profile(id: String) async throws -> OpenDota.ODUserProfile {
        let data = try fileReader.readFile("player_yatoro")
        return try decoder.decode(ODUserProfile.self, from: data)
    }
}
