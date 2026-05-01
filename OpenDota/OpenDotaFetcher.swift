//
//  OpenDotaFetcher.swift
//  OpenDota
//
//  Created by Shibo Tong on 1/5/2026.
//

import Foundation

nonisolated
public protocol OpenDotaFetching {
    func constants(service: OpenDotaFetcher.ConstantService) async throws -> Any
}

public class OpenDotaFetcher: OpenDotaFetching {
    nonisolated public static let shared = OpenDotaFetcher()
    
    private let baseURL = "https://api.opendota.com"
    
    public func constants(service: ConstantService) async throws -> Any {
        guard let url = URL(string: "\(baseURL)/api/constants/\(service.rawValue)") else {
            throw URLError(.badURL)
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return try JSONSerialization.jsonObject(with: data)
    }
}

