//
//  DataProvider.swift
//  D2A
//
//  Created by Shibo Tong on 6/12/2025.
//

import Foundation

protocol DataProviding {
    func data(urlString: String, query: [String: Any]?) async throws -> Data
}

extension DataProviding {
    func data(urlString: String) async throws -> Data {
        try await data(urlString: urlString, query: nil)
    }
}

struct DataProvider: DataProviding {
    func data(urlString: String, query: [String: Any]? = nil) async throws -> Data {
        guard var components = URLComponents(string: urlString) else {
            throw URLError(.badURL)
        }
        if let query = query {
            components.queryItems = query.map { key, value in
                URLQueryItem(name: key, value: "\(value)")
            }
        }
        guard let url = components.url else {
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
