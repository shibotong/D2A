//
//  OpenDotaConstantFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

import Foundation

protocol OpenDotaConstantFetching {
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
    
    func heroes() async throws -> [String: ODHero] {
        guard let url = URL(string: "\(baseURL)/heroes") else {
            return [:]
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let heroesDictionary = try decoder.decode([String: ODHero].self, from: data)
        return heroesDictionary
    }
}
