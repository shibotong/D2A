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

public final class OpenDotaFetcher: OpenDotaFetching {
    
    public static let shared = OpenDotaFetcher()
    
    private let apiClient: APIClientProtocol
    
    private let baseURL = "https://api.opendota.com/api"
    
    private let snakeDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)

            let fractionalFormatter = ISO8601DateFormatter()
            fractionalFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            if let date = fractionalFormatter.date(from: dateString) {
                return date
            }

            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            if let date = formatter.date(from: dateString) {
                return date
            }

            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid date format: \(dateString)"
            )
        }
        return decoder
    }()
    
    public init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    // MARK: - Constants
    
    public func abilities() async throws -> [String: ODAbility] {
        let url = createURL("constants/abilities")
        return try await doNetworkCall(url, decoder: snakeDecoder, as: [String: ODAbility].self)
    }
    
    public func abilityIDs() async throws -> [String: String] {
        let url = createURL("constants/ability_ids")
        return try await doNetworkCall(url, decoder: snakeDecoder, as: [String: String].self)
    }
    
    public func heroes() async throws -> [String: ODHero] {
        let url = createURL("constants/heroes")
        return try await doNetworkCall(url, decoder: snakeDecoder, as: [String: ODHero].self)
    }
    
    public func heroAbilities() async throws -> [String : ODHeroAbility] {
        let url = createURL("constants/hero_abilities")
        return try await doNetworkCall(url, decoder: snakeDecoder, as: [String: ODHeroAbility].self)
    }
    
    // MARK: - OpenDota
    
    public func match(id: String) async throws -> ODMatch {
        let url = createURL("matches/\(id)")
        return try await doNetworkCall(url, decoder: snakeDecoder, as: ODMatch.self)
    }
    
    public func profile(id: String) async throws -> ODUserProfile {
        let url = createURL("players/\(id)")
        return try await doNetworkCall(url, decoder: snakeDecoder, as: ODUserProfile.self)
    }
    
    public func searchPlayer(personaname: String) async throws  {
        
    }
    
    private func createURL(_ path: String) -> String {
        return "\(baseURL)/\(path)"
    }
    
    private func doNetworkCall<T: Decodable>(_ path: String, decoder: JSONDecoder, as type: T.Type) async throws(ODError) -> T {
        do {
            let (data, response) = try await apiClient.get(path)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw ODError.invalidHTTPResponse
            }
            switch httpResponse.statusCode {
            case 400...599:
                let error = try decoder.decode(ODError.self, from: data)
                throw error
            default:
                return try decoder.decode(T.self, from: data)
            }
        } catch let error as ODError {
            throw error
        } catch let error as DecodingError {
            throw ODError(error: "The response structure doesn't match.")
        } catch let error as APIClientError {
            throw ODError(error: error.message)
        } catch {
            throw ODError.unknown
        }

    }
}
