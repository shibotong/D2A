//
//  D2ANetwork.swift
//  D2A
//
//  Created by Shibo Tong on 6/12/2025.
//

import UIKit

protocol D2ANetworking {
    func jsonObject(urlString: String) async throws -> [String: Any]
    func jsonArray(urlString: String) async throws -> [[String: Any]]
    func image(urlString: String) async throws -> UIImage
}

struct D2ANetwork: D2ANetworking {
    func jsonObject(urlString: String) async throws -> [String : Any] {
        let data = try await data(urlString: urlString)
        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw URLError(.cannotDecodeRawData)
        }
        return jsonObject
    }
    
    func jsonArray(urlString: String) async throws -> [[String : Any]] {
        let data = try await data(urlString: urlString)
        guard let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            throw URLError(.cannotDecodeRawData)
        }
        return jsonArray
    }
    
    func image(urlString: String) async throws -> UIImage {
        let data = try await data(urlString: urlString)
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeRawData)
        }
        return image
    }
    
    private func data(urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        return data
    }
}
