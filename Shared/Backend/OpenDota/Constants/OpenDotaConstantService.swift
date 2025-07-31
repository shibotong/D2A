//
//  OpenDotaConstantService.swift
//  D2A
//
//  Created by Shibo Tong on 1/5/2025.
//

import Foundation

enum OpenDotaConstantService: String, CaseIterable {
    
    static let githubURL = "https://raw.githubusercontent.com/odota/dotaconstants/master/build"
    static let openDotaURL = "https://api.opendota.com/api/constants"
    
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
        serviceURL(source: .opendota)
    }
    
    private enum Source {
        case github, opendota
    }
    
    private func serviceURL(source: Source) -> String {
        switch source {
        case .github:
            return "\(Self.githubURL)/\(rawValue).json"
        case .opendota:
            return "\(Self.openDotaURL)/\(rawValue)"
        }
    }
}
