//
//  OpenDotaConstantController.swift
//  D2A
//
//  Created by Shibo Tong on 27/4/2025.
//

protocol OpenDotaConstantProviding {
    func loadHeroes() async -> [String: HeroCodable]
}

class OpenDotaConstantController: OpenDotaConstantProviding {
    
    static let shared = OpenDotaConstantController()
    
    func loadHeroes() async -> [String : HeroCodable] {
        let heroURL = OpenDotaConstantService.heroes.serviceURL
        do {
            let heroes = try await D2ANetwork.default.dataTask(heroURL, as: [String: HeroCodable].self)
            return heroes
        } catch {
            logWarn("Loading heroes from OpenDotaConstantController failed: \(error.localizedDescription)")
            return [:]
        }
    }
}

class MockOpenDotaConstantProvider: OpenDotaConstantProviding
