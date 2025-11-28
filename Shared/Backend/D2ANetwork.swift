//
//  Network.swift
//  D2A
//
//  Created by Shibo Tong on 28/11/2025.
//

import Foundation

protocol NetworkProviding {
    func request(urlString: String) async throws -> Any
}

struct D2ANetworkProvider: NetworkProviding {

    static let shared = D2ANetworkProvider()
    
    func request(urlString: String) async throws -> Any {
        guard let url = URL(string: urlString) else {
            throw D2AError(description: "The URL is not valid. \(urlString)")
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData
    }
}
