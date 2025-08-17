//
//  D2ANetwork.swift
//  D2A
//
//  Created by Shibo Tong on 1/5/2025.
//

import Foundation
import UIKit

protocol D2ANetworking {
    func dataTask<T: Decodable>(_ urlString: String, as type: T.Type) async throws -> T
    func dataTask(_ urlString: String) async throws -> Any
    func remoteImage(_ urlString: String) async throws -> UIImage?
}

class D2ANetwork: D2ANetworking {
    static let `default` = D2ANetwork()
    
    func dataTask(_ urlString: String) async throws -> Any {
        let data = try await data(urlString)
        return try JSONSerialization.jsonObject(with: data)
    }

    func dataTask<T: Decodable>(_ urlString: String, as type: T.Type) async throws -> T {
        let data = try await data(urlString)
        let jsonData = try JSONDecoder().decode(T.self, from: data)
        return jsonData
    }
    
    private func data(_ urlString: String) async throws -> Data {
        guard let url = URL(string: urlString) else {
            throw D2AError(message: "url is not valid: \(urlString)")
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        return data
    }
    
    func remoteImage(_ urlString: String) async throws -> UIImage? {
        guard let url = URL(string: urlString),
              let (newImageData, _) = try? await URLSession.shared.data(from: url),
              let newImage = UIImage(data: newImageData) else {
            return nil
        }
        return newImage
    }
}
