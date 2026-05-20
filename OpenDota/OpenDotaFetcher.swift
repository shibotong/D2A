//
//  OpenDotaFetcher.swift
//  OpenDota
//
//  Created by Shibo Tong on 1/5/2026.
//

import Foundation
import Networking

public protocol OpenDotaFetching {
    func constants(service: OpenDotaFetcher.ConstantService) async throws -> Any
}

public class OpenDotaFetcher: OpenDotaFetching {
    public static let shared = OpenDotaFetcher()
    
    private let baseURL = "https://api.opendota.com"
    private let client: APIClientProtocol
    
    public init(client: APIClientProtocol = APIClient.shared) {
        self.client =  client
    }
    
    nonisolated
    public func constants(service: ConstantService) async throws -> Any {
        guard let url = URL(string: "\(baseURL)/api/constants/\(service.rawValue)") else {
            throw URLError(.badURL)
        }
        let data = try await client.url(url)
        return try JSONSerialization.jsonObject(with: data)
    }
}

