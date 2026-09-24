//
//  LobbyType.swift
//  App
//
//  Created by Shibo Tong on 28/8/21.
//

import Foundation

enum LobbyType: String {
    case NORMAL
    case PRACTICE
    case TOURNAMENT
    case TUTORIAL
    case COOP_BOTS
    case RANKED_TEAM_MM
    case RANKED_SOLO_MM
    case RANKED
    case MID_1V1
    case BATTLE_CUP
    case LOCAL_BOTS
    case SPECTATOR
    case EVENT
    case GAUNTLET
    case NEW_PLAYER
    case FEATURED
    case UNKNOWN
    
    static func from(id: Int) -> LobbyType {
        switch id {
        case 0:
            return .NORMAL
        case 1:
            return .PRACTICE
        case 2:
            return .TOURNAMENT
        case 3:
            return .TUTORIAL
        case 4:
            return .COOP_BOTS
        case 5:
            return .RANKED_TEAM_MM
        case 6:
            return .RANKED_SOLO_MM
        case 7:
            return .RANKED
        case 8:
            return .MID_1V1
        case 9:
            return .BATTLE_CUP
        case 12:
            return .EVENT
        default:
            return .UNKNOWN
        }
    }
    
    var isRanked: Bool {
        return self == .RANKED_SOLO_MM || self == .RANKED_TEAM_MM || self == .RANKED
    }
    
    var localized: String {
        return NSLocalizedString(rawValue, tableName: "Lobby", comment: "")
    }
}
