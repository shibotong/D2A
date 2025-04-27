//
//  OpenDotaConstantService.swift
//  D2A
//
//  Created by Shibo Tong on 27/4/2025.
//

import Foundation

enum OpenDotaConstantService {
    
    static let baseURL = "https://raw.githubusercontent.com/odota/dotaconstants/master/build"
    
    case heroes
    case abilities
    case abilityIDs
    case heroAbilities
    case aghs
    case items
    case itemIDs
    
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
        }
    }
}
