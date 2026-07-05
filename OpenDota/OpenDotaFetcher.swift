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
}

public class OpenDotaFetcher: OpenDotaFetching {
    
    private let apiClient: APIClientProtocol
    
    private let baseURL = "https://api.opendota.com/api/"
    
    public init(apiClient: APIClientProtocol = APIClient.shared) {
        self.apiClient = apiClient
    }
    
    public func match(id: String) async throws -> [String: Any] {
        guard let url = URL(string: "\(baseURL)/matches/\(id)") else {
            throw ODError.urlError
        }
        let data = try await apiClient.url(url)
        guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw ODError.dataIsNotJson
        }
        return json
    }
}
