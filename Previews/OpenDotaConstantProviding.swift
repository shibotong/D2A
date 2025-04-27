//
//  OpenDotaConstantProviding.swift
//  D2A
//
//  Created by Shibo Tong on 27/4/2025.
//

import Foundation

class MockOpenDotaConstantProviding: OpenDotaConstantProviding {
    func loadHeroes() async -> [String: HeroCodable] {
        guard let data = loadFile(filename: "sampleHero") else {
            return nil
        }
        
        do {
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([String: HeroCodable].self, from: data)
            return jsonData
        } catch {
            debugPrint(error)
            return nil
        }
    }
}
