//
//  GameMode.swift
//  App
//
//  Created by Shibo Tong on 28/8/21.
//

import Foundation

struct GameMode {
    let id: Int
    
    init(id: Int) {
        self.id = id
    }
    
    var modeName: String {
        switch id {
        case 0:
            return NSLocalizedString("GAMEMODE_UNKNOWN", comment: "unknown")
        case 1:
            return NSLocalizedString("GAMEMODE_ALL_PICK", comment: "all pick")
        case 2:
            return NSLocalizedString("GAMEMODE_CAPTAINS_MODE", comment: "Captains mode")
        case 3:
            return NSLocalizedString("GAMEMODE_RANDOM_DRAFT", comment: "Random draft")
        case 4:
            return NSLocalizedString("GAMEMODE_SINGLE_DRAFT", comment: "Single draft")
        case 5:
            return NSLocalizedString("GAMEMODE_ALL_RANDOM", comment: "All random")
        case 6:
            return NSLocalizedString("GAMEMODE_INTRO", comment: "Intro")
        case 7:
            return NSLocalizedString("GAMEMODE_DIRETIDE", comment: "Diretide")
        case 8:
            return NSLocalizedString("GAMEMODE_REVERSE_CAPTAINS_MODE", comment: "Reverse captains mode")
        case 9:
            return NSLocalizedString("GAMEMODE_GREEVILING", comment: "Greeviling")
        case 10:
            return NSLocalizedString("GAMEMODE_TUTORIAL", comment: "Tutorial")
        case 11:
            return NSLocalizedString("GAMEMODE_MID_ONLY", comment: "Mid Only")
        case 12:
            return NSLocalizedString("GAMEMODE_LEAST_PLAYED", comment: "Least Played")
        case 13:
            return NSLocalizedString("GAMEMODE_LIMITED_HEROES", comment: "Limited Heroes")
        case 14:
            return NSLocalizedString("GAMEMODE_COMPENDIUM_MATCHMAKING", comment: "Compendium Matchmaking")
        case 15:
            return NSLocalizedString("GAMEMODE_CUSTOM", comment: "Custom Mode")
        case 16:
            return NSLocalizedString("GAMEMODE_CAPTAINS_DRAFT", comment: "Captains Draft")
        case 17:
            return NSLocalizedString("GAMEMODE_BALANCED_DRAFT", comment: "Balanced Draft")
        case 18:
            return NSLocalizedString("GAMEMODE_ABILITY_DRAFT", comment: "Ability Draft")
        case 19:
            return NSLocalizedString("GAMEMODE_EVENT", comment: "Event")
        case 20:
            return NSLocalizedString("GAMEMODE_DEATH_MATCH", comment: "Death Match")
        case 21:
            return NSLocalizedString("GAMEMODE_1V1_MID", comment: "1v1 Mid")
        case 22:
            return NSLocalizedString("GAMEMODE_ALL_DRAFT", comment: "All Draft")
        case 23:
            return NSLocalizedString("GAMEMODE_TURBO", comment: "Turbo")
        case 24:
            return NSLocalizedString("GAMEMODE_MUTATION", comment: "Mutation")
        case 25:
            return NSLocalizedString("GAMEMODE_COACHES_CHALLENGE", comment: "Coaches Challenge")
        default:
            let stringFormat = NSLocalizedString("GAMEMODE_UNKNOWN %lld", comment: "Unknown Game Mode")
            return String(format: stringFormat, id)
        }
    }
    
}
