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
    
    private let maxHeroID = 150
    
    func loadHeroes() async -> [String: HeroCodable] {
        let heroURL = OpenDotaConstantService.heroes.serviceURL
        do {
            let heroes = try await D2ANetwork.default.dataTask(heroURL, as: [String: HeroCodable].self)
            
            var allHeroes: [HeroCodable] = []
            for i in 1...maxHeroID {
                let heroIDString = "\(i)"
                if let heroCodable = heroes[heroIDString] {
                    allHeroes.append(heroCodable)
                }
            }
            
            saveHeroes(heroes: allHeroes)
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
    
    private func saveHeroes(heroes: [HeroCodable]) {
        
        let viewContext = PersistanceController.shared.container.newBackgroundContext()
        for hero in heroes {
            do {
                _ = try Hero.saveData(model: hero, viewContext: viewContext)
                logDebug("Save hero \(hero.id) successfully", category: .coredata)
            } catch {
                logWarn("Save hero \(hero.id) failed. \(error.localizedDescription)", category: .coredata)
            }
        }
    }
}
