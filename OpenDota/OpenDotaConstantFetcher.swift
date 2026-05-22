//
//  OpenDotaConstantFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 20/5/2026.
//

import Networking
import Foundation

protocol OpenDotaConstantFetching {
    func heroes() async throws -> [String: ODHero]
    func abilities() async throws -> [String: ODAbility]
}

class OpenDotaConstantFetcher: OpenDotaConstantFetching {
    
    static let shared = OpenDotaConstantFetcher()
    
    private let apiClient: APIClientProtocol
    
    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()
    
    private let baseURL = "https://api.opendota.com/api/constants"
    
    init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    func heroes() async throws -> [String: ODHero] {
        let url = try createURL("heroes")
        return try await apiClient.url(url, decoder: decoder, as: [String: ODHero].self)
    }
    
    func abilities() async throws -> [String : ODAbility] {
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
