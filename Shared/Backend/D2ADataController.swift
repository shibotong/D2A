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
    
    func downloadHeroData() async {
        guard let heroData = await constantsController.loadData(urlPath: .hero, decodable: [HeroCodable].self) else {
            return
        }
        do {
            try await coreDataController.insertHeroes(heroes: heroData)
            D2ALogger.shared.log("insert heroes successfully", level: .info)
        } catch {
            D2ALogger.shared.log("Insert hero data failed. Error: \(error.localizedDescription)", level: .error)
        }
    }
    
    func downloadAbilityData() async {
        guard let abilityData = await constantsController.loadData(urlPath: .ability, decodable: [String: AbilityCodable].self) else {
            return
        }
    }
}
