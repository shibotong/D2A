//
//  OpenDotaConstantService.swift
//  D2A
//
//  Created by Shibo Tong on 1/5/2025.
//

import Foundation

enum OpenDotaConstantService: String, CaseIterable {
    
//    static let baseURL = "https://raw.githubusercontent.com/odota/dotaconstants/master/build"
    static let baseURL = "https://api.opendota.com/api/constants"
    
    case abilities
    case abilityIDs = "ability_ids"
    case aghs = "aghs_desc"
    case gameMode = "game_mode"
    case heroes
    case heroAbilities = "hero_abilities"
    case heroLore = "hero_lore"
    case items
    case itemIDs = "item_ids"
    
    
    var serviceURL: String {
        "\(Self.baseURL)/\(rawValue).json"
    }
}
