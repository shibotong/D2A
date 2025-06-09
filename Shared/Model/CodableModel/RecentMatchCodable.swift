//
//  RecentMatchCodable.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation

class RecentMatchCodable: Decodable, Identifiable {
    var id: Int
    var duration: Int
    var mode: Int
    var radiantWin: Bool
    var slot: Int
    var heroID: Int
    var kills: Int
    var deaths: Int
    var assists: Int
    var lobbyType: Int
    var startTime: Int
    var partySize: Int?
    var skill: Int?

    var playerId: Int?
    static let sample = loadRecentMatches()!

    var playerWin: Bool {
        guard slot <= 127 else {
            return !radiantWin
        }
        return radiantWin
    }

    var gameMode: GameMode? {
        return ConstantsController.shared.fetchGameMode(id: Int(mode))
    }

    var gameLobby: LobbyType {
        return ConstantsController.shared.fetchLobby(id: Int(lobbyType))
    }

    enum CodingKeys: String, CodingKey {
        case id = "match_id"
        case duration
        case mode = "game_mode"
        case radiantWin = "radiant_win"
        case slot = "player_slot"
        case heroID = "hero_id"
        case kills
        case deaths
        case assists
        case lobbyType = "lobby_type"
        case startTime = "start_time"
        case playerId
        case partySize = "party_size"
        case skill
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        duration = try container.decodeIfPresent(Int.self, forKey: .duration) ?? 0
        mode = try container.decodeIfPresent(Int.self, forKey: .mode) ?? 0
        slot = try container.decodeIfPresent(Int.self, forKey: .slot) ?? 0
        heroID = try container.decodeIfPresent(Int.self, forKey: .heroID) ?? 0
        radiantWin = try container.decodeIfPresent(Bool.self, forKey: .radiantWin) ?? true
        kills = try container.decodeIfPresent(Int.self, forKey: .kills) ?? 0
        deaths = try container.decodeIfPresent(Int.self, forKey: .deaths) ?? 0
        assists = try container.decodeIfPresent(Int.self, forKey: .assists) ?? 0
        lobbyType = try container.decodeIfPresent(Int.self, forKey: .lobbyType) ?? 0
        startTime = try container.decodeIfPresent(Int.self, forKey: .startTime) ?? 0
        playerId = try container.decodeIfPresent(Int.self, forKey: .playerId) ?? 0
        partySize = try container.decodeIfPresent(Int.self, forKey: .partySize)
        skill = try container.decodeIfPresent(Int.self, forKey: .skill)
    }
}
