//
//  AbilityInsertFetching.swift
//  D2A
//
//  Created by Shibo Tong on 18/9/2024.
//

import Foundation
import StratzAPI

class AbilityInsertFetching {
    
    typealias Localisation = LocaliseQuery.Data.Constants.Ability
    
    let abilityIDTable: [String: String]
    let abilities: [String: AbilityCodable]
    let localisations: [Localisation?]
    let keys: [String]
    
    private var currentIndex = 0
    
    init(abilityIDTable: [String : String], 
         abilities: [String : AbilityCodable],
         localisations: [Localisation?]) {
        self.abilityIDTable = abilityIDTable
        self.abilities = abilities
        self.localisations = localisations
        self.keys = Array(abilityIDTable.keys) as [String]
    }
    
    func next() -> AbilityData? {
        guard currentIndex < keys.count else { return nil }
        let abilityIDString = keys[currentIndex]
        guard let abilityName = abilityIDTable[abilityIDString],
              let ability = abilities[abilityName],
              let abilityID = Int(abilityIDString),
              let localisation = localisations.compactMap({ $0 }).first(where: { $0.name == abilityName }) else {
            Logger.shared.log(level: .warning, message: "nil value found for ability: \(abilityIDString)")
            currentIndex += 1
            return next()
        }
        currentIndex += 1
        return AbilityData(abilityName: abilityName,
                           ability: ability,
                           abilityID: abilityID,
                           localisation: localisation)
    }
}

struct AbilityData {
    
    typealias Localisation = LocaliseQuery.Data.Constants.Ability
    
    let abilityName: String
    let ability: AbilityCodable
    let abilityID: Int
    let localisation: Localisation

}
