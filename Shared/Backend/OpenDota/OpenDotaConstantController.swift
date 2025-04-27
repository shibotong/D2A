//
//  OpenDotaConstantController.swift
//  D2A
//
//  Created by Shibo Tong on 27/4/2025.
//

protocol OpenDotaConstantProviding {
    func loadHeroes() async -> [String: HeroCodable]
    func loadItemIDs() async -> [String: String]
}

class OpenDotaConstantController: OpenDotaConstantProviding {
    
    static let shared = OpenDotaConstantController()
    
    func loadHeroes() async -> [String : HeroCodable] {
        let heroURL = OpenDotaConstantService.heroes.serviceURL
        do {
            let heroes = try await D2ANetwork.default.dataTask(heroURL, as: [String: HeroCodable].self)
            return heroes
        } catch {
            logWarn("Loading heroes from OpenDotaConstantController failed: \(error.localizedDescription)", category: .opendotaConstant)
            return [:]
        }
    }
    
    func loadItemIDs() async -> [String : String] {
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
