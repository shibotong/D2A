//
//  NetworkProvider.swift
//  D2A
//
//  Created by Shibo Tong on 6/12/2025.
//

import UIKit

protocol NetworkProviding {
    func json<T>(urlString: String, as type: T.Type, query: [String: Any]?) async throws -> T
    func image(urlString: String) async throws -> UIImage
}

extension NetworkProviding {
    func json<T>(urlString: String, as type: T.Type) async throws -> T {
        return try await json(urlString: urlString, as: type, query: nil)
    }
}

struct NetworkProvider: NetworkProviding {
    
    static let shared = NetworkProvider()
    
    private let provider: DataProviding
    private let logger: D2ALogger
    
    init(provider: DataProviding = DataProvider(),
         logger: D2ALogger = .shared) {
        self.provider = provider
        self.logger = logger
    }
    
    func json<T>(urlString: String, as type: T.Type, query: [String: Any]?) async throws -> T {
        let data = try await provider.data(urlString: urlString)
        guard let json = try JSONSerialization.jsonObject(with: data) as? T else {
            logger.error("Cannot decode as json object from \(urlString)", category: .network)
            throw URLError(.cannotDecodeRawData)
        }
        return json
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
