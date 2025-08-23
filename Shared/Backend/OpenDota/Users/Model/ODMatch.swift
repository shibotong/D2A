//
//  ODMatch.swift
//  D2A
//
//  Created by Shibo Tong on 30/6/21.
//

import Foundation
import CoreData

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
    
    func update(context: NSManagedObjectContext) -> Match {
        let match = (try? context.fetchOne(type: Match.self, predicate: NSPredicate(format: "id == %@", "\(id)"))) ?? Match(context: context)
        setIfNotEqual(entity: match, path: \.matchID, value: Int64(id))
        setIfNotEqual(entity: match, path: \.direKill, value: Int16(direKill ?? 0))
        setIfNotEqual(entity: match, path: \.radiantKill, value: Int16(radiantKill ?? 0))
        setIfNotEqual(entity: match, path: \.duration, value: Int32(duration))
        setIfNotEqual(entity: match, path: \.radiantWin, value: radiantWin)
        setIfNotEqual(entity: match, path: \.lobbyType, value: Int16(lobbyType))
        setIfNotEqual(entity: match, path: \.mode, value: Int16(mode))
        setIfNotEqual(entity: match, path: \.region, value: Int16(region))
        setIfNotEqual(entity: match, path: \.skill, value: Int16(skill ?? 0))
        setIfNotEqual(entity: match, path: \.startTime, value: Date(timeIntervalSince1970: TimeInterval(startTime)))
        setIfNotEqual(entity: match, path: \.players, value: players.map { Player(player: $0) })
        
        setIfNotEqual(entity: match, path: \.goldDiff, value: goldDiff as [NSNumber]?)
        setIfNotEqual(entity: match, path: \.xpDiff, value: xpDiff as [NSNumber]?)
        return match
    }
}
