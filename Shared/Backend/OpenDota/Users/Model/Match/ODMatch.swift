//
//  ODMatch.swift
//  D2A
//
//  Created by Shibo Tong on 30/6/21.
//

import Foundation
import CoreData

struct ODMatch: Decodable {
    let matchID: Int
    let barrackRadiant: Int
    let barrackDire: Int
    let chat: [Chat]
    
    let cluster: Int
    
    let scoreDire: Int
    let draftTimings: [DraftTime]
    let duration: Int
    let engine: Int
    let firstBloodTime: Int
    let gameMode: Int
    let humanPlayers: Int
    let leagueID: Int
    let lobbyType: Int
    let matchSeqNum: Int
    let negativeVotes: Int
    let pickBans: [PickBan]
    let positiveVotes: Int
    let radiantGoldAdv: [Int]
    let scoreRadiant: Int
    let radiantWin: Bool
    let radiantXpAdv: [Int]
    let startTime: Int
    let towerDire: Int
    let towerRadiant: Int
    
    let teamRadiant: Int
    let teamDire: Int
    let skill: Int?
    
    let players: [Player]
    let patch: Int
    let region: Int
    
    enum CodingKeys: String, CodingKey {
        case matchID = "match_id"
        case barrackRadiant = "barracks_status_radiant"
        case barrackDire = "barracks_status_dire"
        case chat
        case cluster
        case scoreDire = "dire_score"
        case draftTimings = "draft_timings"
        case duration
        case engine
        case firstBloodTime = "first_blood_time"
        case gameMode = "game_mode"
        case humanPlayers = "human_players"
        case leagueID = "leaguesid"
        case lobbyType = "lobby_type"
        case matchSeqNum = "match_seq_num"
        case negativeVotes = "negative_votes"
        case pickBans = "picks_bans"
        case positiveVotes = "positive_votes"
        case radiantGoldAdv = "radiant_gold_adv"
        case scoreRadiant = "radiant_score"
        case radiantWin = "radiant_win"
        case radiantXpAdv = "radiant_xp_adv"
        case startTime = "start_tiem"
        case towerDire = "tower_status_dire"
        case towerRadiant = "tower_status_radiant"
        case teamRadiant = "radiant_team"
        case teamDire = "dire_team"
        case skill
        case players
        case patch
        case region
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.matchID = try container.decode(Int.self, forKey: .matchID)
        self.barrackRadiant = try container.decode(Int.self, forKey: .barrackRadiant)
        self.barrackDire = try container.decode(Int.self, forKey: .barrackDire)
        self.chat = try container.decode([ODMatch.Chat].self, forKey: .chat)
        self.cluster = try container.decode(Int.self, forKey: .cluster)
        self.scoreDire = try container.decode(Int.self, forKey: .scoreDire)
        self.draftTimings = try container.decode([ODMatch.DraftTime].self, forKey: .draftTimings)
        self.duration = try container.decode(Int.self, forKey: .duration)
        self.engine = try container.decode(Int.self, forKey: .engine)
        self.firstBloodTime = try container.decode(Int.self, forKey: .firstBloodTime)
        self.gameMode = try container.decode(Int.self, forKey: .gameMode)
        self.humanPlayers = try container.decode(Int.self, forKey: .humanPlayers)
        self.leagueID = try container.decode(Int.self, forKey: .leagueID)
        self.lobbyType = try container.decode(Int.self, forKey: .lobbyType)
        self.matchSeqNum = try container.decode(Int.self, forKey: .matchSeqNum)
        self.negativeVotes = try container.decode(Int.self, forKey: .negativeVotes)
        self.pickBans = try container.decode([ODMatch.PickBan].self, forKey: .pickBans)
        self.positiveVotes = try container.decode(Int.self, forKey: .positiveVotes)
        self.radiantGoldAdv = try container.decode([Int].self, forKey: .radiantGoldAdv)
        self.scoreRadiant = try container.decode(Int.self, forKey: .scoreRadiant)
        self.radiantWin = try container.decode(Bool.self, forKey: .radiantWin)
        self.radiantXpAdv = try container.decode([Int].self, forKey: .radiantXpAdv)
        self.startTime = try container.decode(Int.self, forKey: .startTime)
        self.towerDire = try container.decode(Int.self, forKey: .towerDire)
        self.towerRadiant = try container.decode(Int.self, forKey: .towerRadiant)
        self.teamRadiant = try container.decode(Int.self, forKey: .teamRadiant)
        self.teamDire = try container.decode(Int.self, forKey: .teamDire)
        self.skill = try container.decodeIfPresent(Int.self, forKey: .skill)
        self.players = try container.decode([ODMatch.Player].self, forKey: .players)
        self.patch = try container.decode(Int.self, forKey: .patch)
        self.region = try container.decode(Int.self, forKey: .region)
    }
}
