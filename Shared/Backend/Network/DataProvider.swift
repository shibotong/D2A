//
//  DataProvider.swift
//  D2A
//
//  Created by Shibo Tong on 6/12/2025.
//

import Foundation

protocol DataProviding {
    func data(urlString: String) async throws -> Data
}

struct DataProvider: DataProviding {
    func data(urlString: String) async throws -> Data {
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
