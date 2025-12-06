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
    private let logger: D2ALogger
    
    init(provider: DataProviding = DataProvider(),
         logger: D2ALogger = .shared) {
        self.provider = provider
        self.logger = logger
    }
    
    func jsonObject(urlString: String) async throws -> [String : Any] {
        let data = try await provider.data(urlString: urlString)
        guard let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            logger.error("Cannot decode as json object from \(urlString)", category: .network)
            throw URLError(.cannotDecodeRawData)
        }
        return jsonObject
    }
    
    func jsonArray(urlString: String) async throws -> [[String : Any]] {
        let data = try await provider.data(urlString: urlString)
        guard let jsonArray = try JSONSerialization.jsonObject(with: data) as? [[String: Any]] else {
            logger.error("Cannot decode as json array from \(urlString)", category: .network)
            throw URLError(.cannotDecodeRawData)
        }
        return jsonArray
    }
    
    func image(urlString: String) async throws -> UIImage {
        let data = try await provider.data(urlString: urlString)
        guard let image = UIImage(data: data) else {
            logger.error("Cannot decode as image from \(urlString)", category: .network)
            throw URLError(.cannotDecodeRawData)
        }
        return image
    }
}
