//
//  D2ANetwork.swift
//  D2A
//
//  Created by Shibo Tong on 27/4/2025.
//

import Foundation

class D2ANetwork {
    static let `default` = D2ANetwork()
    
    func dataTask<T: Decodable>(_ url: String, as type: T.Type) async throws -> T {
        let urlString = "https://raw.githubusercontent.com/odota/dotaconstants/master/build/heroes.json"
        guard let url = URL(string: urlString) else {
            throw D2AError(message: "url is not valid: \(url)")
        }
        let (data, _) = try await URLSession.shared.data(from: url)
        
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(T.self, from: data)
        return jsonData
    }
}
