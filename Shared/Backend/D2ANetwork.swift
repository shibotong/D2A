//
//  Network.swift
//  D2A
//
//  Created by Shibo Tong on 28/11/2025.
//

import Foundation

protocol NetworkProviding {
    func request(urlString: String) async throws -> Any
    func requestData(urlString: String) async throws -> Data
}

struct D2ANetworkProvider: NetworkProviding {

    static let shared = D2ANetworkProvider()
    
    func request(urlString: String) async throws -> Any {
        guard let url = URL(string: urlString) else {
            throw D2AError(description: "The URL is not valid. \(urlString)")
        }
        let data = try await requestData(urlString: urlString)
        let jsonData = try JSONSerialization.jsonObject(with: data)
        return jsonData
    }
    
    func requestData(urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw D2AError(description: "The URL is not valid. \(urlString)")
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, (200..<300).contains(http.statusCode) else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
