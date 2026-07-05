//
//  Secret.swift
//  D2A
//
//  Created by Shibo Tong on 23/9/2022.
//

import Foundation

struct Secrets: Decodable {
    let stratzToken: String
    
    static func load() throws -> Self {
        let secretsFileUrl = Bundle.main.url(forResource: "secrets", withExtension: "json")
        
        guard let secretsFileUrl = secretsFileUrl, let secretsFileData = try? Data(contentsOf: secretsFileUrl) else {
            fatalError("No `secrets.json` file found. Make sure to duplicate `secrets.json.sample` and remove the `.sample` extension.")
        }
        
        return try JSONDecoder().decode(Self.self, from: secretsFileData)
    }
}
