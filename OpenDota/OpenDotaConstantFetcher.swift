//
//  OpenDotaConstantFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 20/5/2026.
//

import Networking
import Foundation

public protocol OpenDotaConstantFetching {
    func heroes() async throws -> [String: ODHero]
    func abilities() async throws -> [String: ODAbility]
}

public class OpenDotaConstantFetcher: OpenDotaConstantFetching {
    
    public static let shared = OpenDotaConstantFetcher()
    
    private let apiClient: APIClientProtocol
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private let baseURL = "https://api.opendota.com/api/constants"
    
    public init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    public func heroes() async throws -> [String: ODHero] {
        let url = try createURL("heroes")
        return try await apiClient.url(url, decoder: decoder, as: [String: ODHero].self)
    }
    
    public func abilities() async throws -> [String : ODAbility] {
        let url = try createURL("abilities")
        return try await apiClient.url(url, decoder: decoder, as: [String: ODAbility].self)
    }
    
    private func createURL(_ path: String) throws -> URL {
        guard let url = URL(string: "\(baseURL)/\(path)") else {
            throw ODError.urlError
        }
        return url
    }
}
