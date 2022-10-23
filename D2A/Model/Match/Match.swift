//
//  Match.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 30/6/21.
//

import Foundation
import WCDBSwift

struct Match: TableCodable {
    var id: Int
    var direKill: Int?
    var duration: Int
    var mode: Int
    var lobbyType: Int
    var radiantKill: Int?
    var radiantWin: Bool?
    var startTime: Int
//    var direBarracks: Int
//    var radiantBarracks: Int
//    var direTowers: Int
//    var radiantTowers: Int
    var skill: Int?
    var region: Int
    
    var goldDiff: [Int]?
    var xpDiff: [Int]?
    
    var players: [Player] = []
    
    var radiantTeam: Team?
    var direTeam: Team?
    
    var buildings: [BuildingEvent] = []
    
    static let sample = loadMatch()!
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Match
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case id = "match_id"
        case direKill = "dire_score"
        case duration
        case mode = "game_mode"
        case lobbyType = "lobby_type"
        case radiantKill = "radiant_score"
        case radiantWin = "radiant_win"
        case startTime = "start_time"
        case players
//        case direBarracks = "barracks_status_dire"
//        case radiantBarracks = "barracks_status_radiant"
//        case direTowers = "tower_status_dire"
//        case radiantTowers = "tower_status_radiant"
        case skill
        case region
        
        case goldDiff = "radiant_gold_adv"
        case xpDiff = "radiant_xp_adv"
    }
    
    init(from matchLive: MatchLive) {
        id = matchLive.matchId ?? 0
        direKill = matchLive.direScore
        duration = matchLive.gameTime ?? 0
        mode = 0
        lobbyType = 0
        radiantKill = matchLive.radiantScore
        startTime = matchLive.createdDateTime ?? 0
        region = 0
        
        players = matchLive.players?.compactMap { $0 }.map { Player(from: $0) } ?? []
        radiantTeam = Team(from: matchLive.radiantTeam)
        direTeam = Team(from: matchLive.direTeam)
        
        buildings = matchLive.playbackData?.buildingEvents?.compactMap{ $0 }.map { BuildingEvent(from: $0) } ?? []
    }
    
    func fetchDuration() -> String {
        let mins = Int(self.duration / 60)
        let sec = Int(self.duration - (mins * 60))
        return "\(mins):\(sec)"
    }
    
    func fetchStartTime() -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(startTime))
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy,MMM,dd"
        return formatter.string(from: date)
    }
    
    func fetchPlayers(isRadiant: Bool) -> [Player] {
        return players.filter({ isRadiant ? $0.slot <= 127 :  $0.slot > 127 })
    }
    
    func fetchKill(isRadiant: Bool) -> Int {
        if isRadiant {
            if self.radiantKill != nil {
                return self.radiantKill!
            } else {
                let players = self.fetchPlayers(isRadiant: isRadiant)
                var kills = 0
                players.forEach { player in
                    kills += player.kills
                }
                return kills
            }
        } else {
            if self.direKill != nil {
                return self.direKill!
            } else {
                let players = self.fetchPlayers(isRadiant: isRadiant)
                var countKills = 0
                players.forEach { player in
                    countKills += player.kills
                }
                return countKills
            }
        }
    }
}

struct PermanentBuff: TableCodable {
    var buffID: Int
    var stack: Int
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = PermanentBuff
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case buffID = "permanent_buff"
        case stack = "stack_count"
    }
}
