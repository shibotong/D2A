//
//  Match.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 30/6/21.
//

import Foundation
import WCDBSwift

struct GameMode: Codable {
    var id: Int
    var name: String
    
    func fetchModeName() -> String {
        switch self.id {
        case 0:
            return "Unknown"
        case 1:
            return "All Pick"
        case 2:
            return "Captains Mode"
        case 3:
            return "Random Draft"
        case 4:
            return "Single Draft"
        case 5:
            return "All Random"
        case 6:
            return "Intro"
        case 7:
            return "Diretide"
        case 8:
            return "Reverse Captains Mode"
        case 9:
            return "Greeviling"
        case 10:
            return "Tutorial"
        case 11:
            return "Mid Only"
        case 12:
            return "Least Played"
        case 13:
            return "Limited Heroes"
        case 14:
            return "Compendium Matchmaking"
        case 15:
            return "Custom Mode"
        case 16:
            return "Captains Draft"
        case 17:
            return "Balanced Draft"
        case 18:
            return "Ability Draft"
        case 19:
            return "Event"
        case 20:
            return "Death Match"
        case 21:
            return "1v1 Mid"
        case 22:
            return "All Pick"
        case 23:
            return "Turbo"
        case 24:
            return "Mutation"
        default:
            return "Unknown Mode"
        }
    }
    
}

struct Match: TableCodable {
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
    
    var players: [Player]
    
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
        case direBarracks = "barracks_status_dire"
        case radiantBarracks = "barracks_status_radiant"
        case direTowers = "tower_status_dire"
        case radiantTowers = "tower_status_radiant"
        case skill
        case region
        
        case goldDiff = "radiant_gold_adv"
        case xpDiff = "radiant_xp_adv"
    }
    
    static var sample = loadMatch()!
    
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

struct Player: Codable, TableCodable {
    var id: Int?
    var slot: Int
    var abilityUpgrade: [Int]? //An array describing how abilities were upgraded
    
    // backpack
    var backpack0: Int?
    var backpack1: Int?
    var backpack2: Int?
    // item
    var item0:Int
    var item1: Int
    var item2: Int
    var item3: Int
    var item4: Int
    var item5: Int
    var itemNeutral: Int?
    
//     K/D/A lasthit/deny
    var kills: Int
    var deaths: Int
    var assists: Int
    var lastHits: Int
    var denies: Int

    var gpm: Int
    var gold_t: [Int]?
    var netWorth: Int?
    var xpm: Int
    var xp_t: [Int]?

    var heroDamage: Int?
    var heroHealing: Int?

    var heroID: Int
    var level: Int

    var permanentBuffs: [PermanentBuff]?

    var teamFightParticipation: Double?
    var towerDamage: Int?

    var personaname: String?
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Player
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case id = "account_id"
        case slot = "player_slot"
        case abilityUpgrade = "ability_upgrades_arr"
       
        // backpack
        case backpack0 = "backpack_0"
        case backpack1 = "backpack_1"
        case backpack2 = "backpack_2"
        //items
        case item0 = "item_0"
        case item1 = "item_1"
        case item2 = "item_2"
        case item3 = "item_3"
        case item4 = "item_4"
        case item5 = "item_5"
        case itemNeutral = "item_neutral"
        // KDA
        case deaths
        case denies
        case assists
        case kills
        case lastHits = "last_hits"

        case gpm = "gold_per_min"
        case gold_t
        case xpm = "xp_per_min"
        case xp_t
        case netWorth = "net_worth"

        case heroDamage = "hero_damage"
        case heroHealing = "hero_healing"
        case heroID = "hero_id"
        case level

        case permanentBuffs = "permanent_buffs"
        case teamFightParticipation = "teamfight_participation"
        case towerDamage = "tower_damage"

        case personaname
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
