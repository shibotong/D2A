//
//  ODMatch.swift
//  D2A
//
//  Created by Shibo Tong on 30/6/21.
//

import Foundation

struct ODMatch: Decodable {
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

    static let emptyMatch = ODMatch(
        id: 0, duration: 0, mode: 0, lobbyType: 0, radiantWin: false, startTime: 0, direBarracks: 0,
        radiantBarracks: 0, direTowers: 0, radiantTowers: 0, region: 0)

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
}
