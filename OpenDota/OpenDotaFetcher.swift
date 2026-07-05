//
//  OpenDotaFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 5/7/2026.
//

import Networking
import Foundation

public protocol OpenDotaFetching {
    func match(id: String) async throws -> [String: Any]
    func profile(id: String) async throws -> ODUserProfile
}

public class OpenDotaFetcher: OpenDotaFetching {
    
    private let apiClient: APIClientProtocol
    
    private let baseURL = "https://api.opendota.com/api"
    
    public init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    public func match(id: String) async throws -> [String: Any] {
        let url = try createURL(path: "matches/\(id)")
        let data = try await apiClient.url(url)
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw ODError.dataIsNotJson
        }
        return json
    }
    
    public func profile(id: String) async throws -> ODUserProfile {
        let url = try createURL(path: "players/\(id)")
        return try await apiClient.url(url, decoder: snakeDecoder, as: ODUserProfile.self)
    }
    
    private func createURL(path: String) throws -> URL {
        guard let url = URL(string: "\(baseURL)/\(path)") else {
            throw ODError.urlError
        }
        return url
    }
}
