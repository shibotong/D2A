//
//  GameMode.swift
//  App
//
//  Created by Shibo Tong on 28/8/21.
//

import Foundation

enum GameMode: String {
    case UNKNOWN
    case ALL_PICK
    case CAPTAINS_MODE
    case RANDOM_DRAFT
    case SINGLE_DRAFT
    case ALL_RANDOM
    case INTRO
    case DIRETIDE
    case REVERSE_CAPTAINS_MODE
    case GREEVILING
    case TUTORIAL
    case MID_ONLY
    case LEAST_PLAYED
    case LIMITED_HEROES
    case COMPENDIUM_MATCHMAKING
    case CUSTOM
    case CAPTAINS_DRAFT
    case BALANCED_DRAFT
    case ABILITY_DRAFT
    case EVENT
    case DEATH_MATCH
    case MID_1V1
    case ALL_DRAFT
    case TURBO
    case MUTATION
    case COACHES_CHALLENGE
    case UNDEFINED

    static func from(modeId: Int) -> GameMode {
        switch modeId {
        case 0:
            return .UNKNOWN
        case 1:
            return .ALL_PICK
        case 2:
            return .CAPTAINS_MODE
        case 3:
            return .RANDOM_DRAFT
        case 4:
            return .SINGLE_DRAFT
        case 5:
            return .ALL_RANDOM
        case 6:
            return .INTRO
        case 7:
            return .DIRETIDE
        case 8:
            return .REVERSE_CAPTAINS_MODE
        case 9:
            return .GREEVILING
        case 10:
            return .TUTORIAL
        case 11:
            return .MID_ONLY
        case 12:
            return .LEAST_PLAYED
        case 13:
            return .LIMITED_HEROES
        case 14:
            return .COMPENDIUM_MATCHMAKING
        case 15:
            return .CUSTOM
        case 16:
            return .CAPTAINS_DRAFT
        case 17:
            return .BALANCED_DRAFT
        case 18:
            return .ABILITY_DRAFT
        case 19:
            return .EVENT
        case 20:
            return .DEATH_MATCH
        case 21:
            return .MID_1V1
        case 22:
            return .ALL_DRAFT
        case 23:
            return .TURBO
        case 24:
            return .MUTATION
        case 25:
            return .COACHES_CHALLENGE
        default:
            return .UNDEFINED
        }
    }
    
    var localized: String {
        return NSLocalizedString(rawValue, tableName: "GameMode", comment: "")
    }
}
