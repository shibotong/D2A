//
//  D2ANetwork.swift
//  D2A
//
//  Created by Shibo Tong on 1/5/2025.
//

import Foundation

class D2ANetwork {
    static let `default` = D2ANetwork()

    func dataTask<T: Decodable>(_ urlString: String, as type: T.Type) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw D2AError(message: "url is not valid: \(urlString)")
        }
        let (data, _) = try await URLSession.shared.data(from: url)

        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(T.self, from: data)
        return jsonData
    }
}
