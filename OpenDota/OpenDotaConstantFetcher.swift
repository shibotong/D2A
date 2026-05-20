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
        let url = URL(string: "\(baseURL)/heroes")!
        return try await apiClient.url(url, decoder: decoder, as: [String: ODHero].self)
    }
}
