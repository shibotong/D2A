//
//  NetworkProvider.swift
//  D2A
//
//  Created by Shibo Tong on 6/12/2025.
//

import UIKit

protocol NetworkProviding {
    func jsonObject(urlString: String) async throws -> [String: Any]
    func jsonArray(urlString: String) async throws -> [[String: Any]]
    func image(urlString: String) async throws -> UIImage
}

struct NetworkProvider: NetworkProviding {
    
    private let provider: DataProviding
    
    init(provider: DataProviding = DataProvider()) {
        self.provider = provider
    }
    
    func jsonObject(urlString: String) async throws -> [String : Any] {
        let data = try await provider.data(urlString: urlString)
        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw URLError(.cannotDecodeRawData)
        }
        return jsonObject
    }
    
    func jsonArray(urlString: String) async throws -> [[String : Any]] {
        let data = try await provider.data(urlString: urlString)
        guard let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            throw URLError(.cannotDecodeRawData)
        }
        return jsonArray
    }
    
    func image(urlString: String) async throws -> UIImage {
        let data = try await provider.data(urlString: urlString)
        guard let image = UIImage(data: data) else {
            throw URLError(.cannotDecodeRawData)
        }
        return image
    }
}
