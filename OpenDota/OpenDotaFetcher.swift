//
//  OpenDotaConstantFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 20/5/2026.
//

import Networking
import Foundation

public protocol OpenDotaFetching: Sendable {
    func abilities() async throws -> [String: ODAbility]
    func abilityIDs() async throws -> [String: String]
    func heroes() async throws -> [String: ODHero]
    func heroAbilities() async throws -> [String: ODHeroAbility]
    
    func match(id: String) async throws -> ODMatch
    func profile(id: String) async throws -> ODUserProfile
}

public class OpenDotaFetcher: OpenDotaFetching {
    
    public static let shared = OpenDotaFetcher()
    
    private let apiClient: APIClientProtocol
    
    private let baseURL = "https://api.opendota.com/api"
    
    private let snakeDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    
    public init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    // MARK: - Constants
    
    public func abilities() async throws -> [String: ODAbility] {
        let url = try createURL("constants/abilities")
        return try await apiClient.url(url, decoder: snakeDecoder, as: [String: ODAbility].self)
    }
    
    public func abilityIDs() async throws -> [String: String] {
        let url = try createURL("constants/ability_ids")
        return try await apiClient.url(url, decoder: snakeDecoder, as: [String: String].self)
    }
    
    public func heroes() async throws -> [String: ODHero] {
        let url = try createURL("constants/heroes")
        return try await apiClient.url(url, decoder: snakeDecoder, as: [String: ODHero].self)
    }
    
    public func heroAbilities() async throws -> [String : ODHeroAbility] {
        let url = try createURL("constants/hero_abilities")
        return try await apiClient.url(url, decoder: snakeDecoder, as: [String: ODHeroAbility].self)
    }
    
    // MARK: - OpenDota
    
    public func match(id: String) async throws -> ODMatch {
        let url = try createURL("matches/\(id)")
        return try await apiClient.url(url, decoder: snakeDecoder, as: ODMatch.self)
    }
    
    public func profile(id: String) async throws -> ODUserProfile {
        let url = try createURL("players/\(id)")
        return try await apiClient.url(url, decoder: snakeDecoder, as: ODUserProfile.self)
    }
    
    private func createURL(_ path: String) throws -> URL {
        guard let url = URL(string: "\(baseURL)/\(path)") else {
            throw ODError.urlError
        }
        return url
    }
}
