//
//  LobbyType.swift
//  App
//
//  Created by Shibo Tong on 28/8/21.
//

import Foundation

struct LobbyType: Codable {
    let id: Int
    var lobbyName: String {
        switch id {
        case 0:
            return "Normal"
        case 1:
            return "Practice"
        case 2:
            return "Tournament"
        case 3:
            return "Tutorial"
        case 4:
            return "Bots"
        case 5, 6, 7:
            return "Ranked"
        case 8:
            return "1v1 mid"
        case 9:
            return "Battle Cup"
        case 12:
            return "Event"
        default:
            return "Unknown (\(id))"
        }
    }
    
    var isRanked: Bool {
        return id == 5 || id == 6 || id == 7
    }
    
    var localized: String {
        switch id {
        case 0:
            return String(localized: .Lobby.normal)
        case 1:
            return String(localized: .Lobby.practice)
        case 2:
            return String(localized: .Lobby.tournament)
        case 3:
            return String(localized: .Lobby.tutorial)
        case 4:
            return String(localized: .Lobby.coopBots)
        case 5:
            return String(localized: .Lobby.rankedTeamMm)
        case 6:
            return String(localized: .Lobby.rankedSoloMm)
        case 7:
            return String(localized: .Lobby.ranked)
        case 8:
            return String(localized: .Lobby.mid1V1)
        case 9:
            return String(localized: .Lobby.battleCup)
        case 10:
            return String(localized: .Lobby.localBots)
        case 11:
            return String(localized: .Lobby.spectator)
        case 12:
            return String(localized: .Lobby.event)
        case 13:
            return String(localized: .Lobby.gauntlet)
        case 14:
            return String(localized: .Lobby.newPlayer)
        case 15:
            return String(localized: .Lobby.featured)
        default:
            return String(localized: .Lobby.unknown)
        }
    }
}
