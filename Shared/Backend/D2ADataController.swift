//
//  D2ADataController.swift
//  D2A
//
//  Created by Shibo Tong on 9/11/2024.
//

import Foundation

class D2ADataController {
    static let shared = D2ADataController()
    
    private let constantsController: ConstantController
    private let coreDataController: CoreDataController
    
    init(dotaConstantController: ConstantController = DotaConstantController.shared,
         persistanceController: CoreDataController = PersistenceController.shared) {
        constantsController = dotaConstantController
        coreDataController = persistanceController
    }
    
    func downloadData() async {
        await downloadHeroData()
        await downloadAbilityData()
    }
    
    private func downloadHeroData() async {
        guard let heroData = await constantsController.loadData(urlPath: .hero, decodable: [HeroCodable].self) else {
            return
        }
        do {
            try await coreDataController.insertHeroes(heroes: heroData)
        } catch {
            D2ALogger.shared.log("Insert hero data failed. Error: \(error.localizedDescription)", level: .error)
        }
    }
    
    private func downloadAbilityData() async {
        async let abilitiesDataFetch = constantsController.loadData(urlPath: .ability, decodable: [String: AbilityCodable].self)
        async let abilitiesIDFetch = constantsController.loadData(urlPath: .abilityID, decodable: [String: String].self)
        guard let abilitiesData = await abilitiesDataFetch, let abilitiesID = await abilitiesIDFetch else {
            return
        }
        do {
            try await coreDataController.insertAbilities(abilities: abilitiesData, idTable: abilitiesID)
        } catch {
            D2ALogger.shared.log("Insert ability data failed. Error: \(error.localizedDescription)", level: .error)
        }
    }
}
