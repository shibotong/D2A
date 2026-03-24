//
//  OpenDotaConstantFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

import Foundation

protocol OpenDotaConstantFetching {
    func abilities() async throws -> [String: ODAbilityV2]
    func abilityIds() async throws -> [String: String]
    func heroes() async throws -> [String: ODHero]
}

class OpenDotaConstantFetcher: OpenDotaConstantFetching {
    
    static let shared = OpenDotaConstantFetcher()
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private let baseURL = "https://api.opendota.com/api/constants"
    
    func abilities() async throws -> [String: ODAbilityV2] {
        return try await loadData(path: "abilities")
    }
    
    func abilityIds() async throws -> [String : String] {
        return try await loadData(path: "ability_ids")
    }
    
    func heroes() async throws -> [String: ODHero] {
        return try await loadData(path: "heroes")
    }
    
    private func loadData<T: Decodable>(path: String) async throws -> T {
        guard let url = URL(string: "\(baseURL)/\(path)") else {
            throw APIError.urlError
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try decoder.decode(T.self, from: data)
    }
}
