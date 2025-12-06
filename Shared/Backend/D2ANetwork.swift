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
        <#code#>
    }
    
    func jsonArray(urlString: String) async throws -> [[String : Any]] {
        <#code#>
    }
    
    func image(urlString: String) async throws -> UIImage {
        <#code#>
    }
    
    private func data(urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(from: url)
        if response
    }
}
