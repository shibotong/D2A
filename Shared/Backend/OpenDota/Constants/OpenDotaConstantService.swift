//
//  OpenDotaConstantService.swift
//  D2A
//
//  Created by Shibo Tong on 1/5/2025.
//

import Foundation

enum OpenDotaConstantService: String, CaseIterable {

    static let baseURL = "https://raw.githubusercontent.com/odota/dotaconstants/master/build"

    case abilities
    case abilityIDs = "ability_ids"
    case aghsDesc = "aghs_desc"
    case countries
    case gameMode = "game_mode"
    case heroAbilities = "hero_abilities"
    case heroLore = "hero_lore"
    case heroes
    
    case itemIDs = "item_ids"
    case items
    case lobbyType = "lobby_type"
    case permanentBuffs = "permanent_buffs"
    case region
    case xpLevel = "xp_level"
    
    var serviceURL: String {
        "\(Self.baseURL)/\(rawValue).json"
    }
}
