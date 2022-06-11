//
//  RecentMatch.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation
import WCDBSwift

class RecentMatch: TableCodable, Identifiable {
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
    var partySize: Int
    var skill: Int?
    
    var playerId: Int?
    static let sample = loadRecentMatches()!
    enum CodingKeys: String, CodingTableKey {
        typealias Root = RecentMatch
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
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
        self.id = try! container.decode(Int.self, forKey: .id)
        if let duration = try container.decodeIfPresent(Int.self, forKey: .duration) {
            self.duration = duration
        } else {
            self.duration = 0
        }
        if let mode = try container.decodeIfPresent(Int.self, forKey: .mode) {
            self.mode = mode
        } else {
            self.mode = 0
        }
        if let slot = try container.decodeIfPresent(Int.self, forKey: .slot) {
            self.slot = slot
        } else {
            self.slot = 0
        }
        if let heroID = try container.decodeIfPresent(Int.self, forKey: .heroID) {
            self.heroID = heroID
        } else {
            self.heroID = 0
        }
        if let radiantWin = try container.decodeIfPresent(Bool.self, forKey: .radiantWin) {
            self.radiantWin = radiantWin
        } else {
            self.radiantWin = false
        }
        if let kills = try container.decodeIfPresent(Int.self, forKey: .kills) {
            self.kills = kills
        } else {
            self.kills = 0
        }
        if let deaths = try container.decodeIfPresent(Int.self, forKey: .deaths) {
            self.deaths = deaths
        } else {
            self.deaths = 0
        }
        if let assists = try container.decodeIfPresent(Int.self, forKey: .assists) {
            self.assists = assists
        } else {
            self.assists = 0
        }
        if let lobbyType = try container.decodeIfPresent(Int.self, forKey: .lobbyType) {
            self.lobbyType = lobbyType
        } else {
            self.lobbyType = 0
        }
        if let startTime = try container.decodeIfPresent(Int.self, forKey: .startTime) {
            self.startTime = startTime
        } else {
            self.startTime = 0
        }
        if let playerId = try container.decodeIfPresent(Int.self, forKey: .playerId) {
            self.playerId = playerId
        } else {
            self.playerId = 0
        }
        if let partySize = try container.decodeIfPresent(Int.self, forKey: .partySize) {
            self.partySize = partySize
        } else {
            self.partySize = 0
        }
        if let skill = try container.decodeIfPresent(Int.self, forKey: .skill) {
            self.skill = skill
        } else {
            self.skill = nil
        }
    }
    
    func isPlayerWin() -> Bool {
        if slot <= 127 {
            return radiantWin
        } else {
            return !radiantWin
        }
    }
    
    func fetchMode() -> GameMode {
        HeroDatabase.shared.fetchGameMode(id: mode)
    }
    
    func fetchLobby() -> LobbyType {
        HeroDatabase.shared.fetchLobby(id: lobbyType)
    }
}
