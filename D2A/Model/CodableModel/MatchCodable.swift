//
//  Match.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 30/6/21.
//

import Foundation

struct MatchCodable: Decodable {
    var id: Int
    var direKill: Int?
    var duration: Int
    var mode: Int
    var lobbyType: Int
    var radiantKill: Int?
    var radiantWin: Bool
    var startTime: Int
    var direBarracks: Int
    var radiantBarracks: Int
    var direTowers: Int
    var radiantTowers: Int
    var skill: Int?
    var region: Int
    
    var goldDiff: [Int]?
    var xpDiff: [Int]?
    
    var players: [PlayerCodable] = []
    
    static let sample = loadMatch()!
    
    static let emptyMatch = MatchCodable(id: 0, duration: 0, mode: 0, lobbyType: 0, radiantWin: false, startTime: 0, direBarracks: 0, radiantBarracks: 0, direTowers: 0, radiantTowers: 0, region: 0)
    
    enum CodingKeys: String, CodingKey {
        case id = "match_id"
        case direKill = "dire_score"
        case duration
        case mode = "game_mode"
        case lobbyType = "lobby_type"
        case radiantKill = "radiant_score"
        case radiantWin = "radiant_win"
        case startTime = "start_time"
        case players
        case direBarracks = "barracks_status_dire"
        case radiantBarracks = "barracks_status_radiant"
        case direTowers = "tower_status_dire"
        case radiantTowers = "tower_status_radiant"
        case skill
        case region
        
        case goldDiff = "radiant_gold_adv"
        case xpDiff = "radiant_xp_adv"
    }
    
//    static var sample = loadMatch()!
    
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
    
    func fetchPlayers(isRadiant: Bool) -> [PlayerCodable] {
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
