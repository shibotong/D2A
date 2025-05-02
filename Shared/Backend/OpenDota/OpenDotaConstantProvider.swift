//
//  OpenDotaConstantProvider.swift
//  D2A
//
//  Created by Shibo Tong on 1/5/2025.
//

import Foundation
protocol OpenDotaConstantProviding {
    func loadHeroes() async -> [String: ODHero]
    func loadItemIDs() async -> [String: String]
}

class OpenDotaConstantProvider: OpenDotaConstantProviding {
    
    static let shared = OpenDotaConstantProvider()
    
    private let maxHeroID = 150
    
    func loadHeroes() async -> [String: ODHero] {
        let heroURL = OpenDotaConstantService.heroes.serviceURL
        do {
            let heroes = try await D2ANetwork.default.dataTask(heroURL, as: [String: ODHero].self)

            return heroes
        } catch {
            logWarn("Loading heroes from OpenDotaConstantController failed: \(error.localizedDescription)", category: .opendotaConstant)
            return [:]
        }
    }
    
    func loadItemIDs() async -> [String: String] {
        let itemIDURL = OpenDotaConstantService.itemIDs.serviceURL
        do {
            let itemIDs = try await D2ANetwork.default.dataTask(itemIDURL, as: [String: String].self)
            return itemIDs
        } catch {
            logWarn("Loading itemIDs from OpenDotaConstantController failed: \(error.localizedDescription)", category: .opendotaConstant)
            return [:]
        }
    }
    

}
