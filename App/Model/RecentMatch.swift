//
//  RecentMatch.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation
import WCDBSwift

class RecentMatch: TableCodable {
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
    
    var playerId: Int?
    
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
}
