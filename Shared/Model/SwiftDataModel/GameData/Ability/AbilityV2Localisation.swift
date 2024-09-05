//
//  AbilityV2Localisation.swift
//  D2A
//
//  Created by Shibo Tong on 1/9/2024.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
class AbilityV2Localisation {
    var localisation: String
    
    var displayName: String
    var lore: String?
    var abilityDescription: String?
    var scepterDescription: String?
    var shardDescription: String?
    
    var ability: AbilityV2?
    
    init(localisation: String, displayName: String = "", lore: String? = nil, abilityDescription: String? = nil) {
        self.localisation = localisation
        self.displayName = displayName
        self.lore = lore
        self.abilityDescription = abilityDescription
    }
}
