//
//  OpenDotaConstantService.swift
//  D2A
//
//  Created by Shibo Tong on 1/5/2025.
//

import Foundation

enum OpenDotaConstantService: String, CaseIterable {
    
    static let baseURL = "https://raw.githubusercontent.com/odota/dotaconstants/master/build"
    
    case heroes
    case abilities
    case abilityIDs = "ability_ids"
    case heroAbilities = "hero_abilities"
    case aghs = "aghs_description"
    case items
    case itemIDs = "item_ids"
    case gameModes = "game_mode"
    
    var serviceURL: String {
        "\(Self.baseURL)/\(name).json"
    }
    
    private var name: String {
        switch self {
        case .heroes:
            "heroes"
        case .abilities:
            "abilities"
        case .abilityIDs:
            "ability_ids"
        case .heroAbilities:
            "hero_abilities"
        case .aghs:
            "aghs_desc"
        case .items:
            "items"
        case .itemIDs:
            "item_ids"
        case .gameModes:
            "game_mode"
        }
    }
}
