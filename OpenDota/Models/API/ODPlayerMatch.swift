//
//  ODPlayerMatch.swift
//  D2A
//
//  Created by Shibo Tong on 2/9/2026.
//

import Foundation

public struct ODPlayerMatch: Decodable {
    public let matchId: Int
    public let playerSlot: Int
    public let radiantWin: Bool?
    public let duration: Int
    public let gameMode: Int
    public let lobbyType: Int
    public let heroId: Int
    public let startTime: Date
    public let version: Int?
    public let kills: Int
    public let deaths: Int
    public let assists: Int
    public let averageRank: Int?
    public let leaverStatus: Int?
    public let partySize: Int?
    public let heroVariant: Int?
    
    public class Optional: Decodable {
        public let matchId: Int
        public var playerSlot: Int?
        public var radiantWin: Bool?
        public var duration: Int?
        public var gameMode: Int?
        public var lobbyType: Int?
        public var heroId: Int?
        public var startTime: Date?
        public var version: Int?
        public var kills: Int?
        public var deaths: Int?
        public var assists: Int?
        public var averageRank: Int?
        public var leaverStatus: Int?
        public var partySize: Int?
        public var heroVariant: Int?
        
        func match() throws -> ODPlayerMatch {
            guard let playerSlot, let duration, let gameMode, let lobbyType, let heroId, let startTime, let kills, let deaths, let assists else {
                throw ODError(error: "Data is not sufficient for creating PlayerMatch. playerSlot: \(String(describing: playerSlot)), duration: \(String(describing: duration)), gameMode: \(String(describing: gameMode)), lobbyType: \(String(describing: lobbyType)), heroId: \(String(describing: heroId)), startTime: \(String(describing: startTime)), kills: \(String(describing: kills)), deaths: \(String(describing: deaths)), assists: \(String(describing: assists))")
            }
            return ODPlayerMatch(matchId: matchId, playerSlot: playerSlot, radiantWin: radiantWin, duration: duration, gameMode: gameMode, lobbyType: lobbyType, heroId: heroId, startTime: startTime, version: version, kills: kills, deaths: deaths, assists: assists, averageRank: averageRank, leaverStatus: leaverStatus, partySize: partySize, heroVariant: heroVariant)
        }
    }
}
