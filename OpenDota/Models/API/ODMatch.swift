//
//  ODMatch.swift
//  D2A
//
//  Created by Shibo Tong on 21/7/2026.
//

public struct ODMatch: Decodable, Sendable {
    public let matchId: Int
    public let startTime: Int
    public let direScore: Int?
    public let duration: Int?
    public let gameMode: Int?
    public let lobbyType: Int?
    public let radiantScore: Int?
    public let radiantWin: Bool?
    public let barracksStatusDire: Int?
    public let barracksStatusRadiant: Int?
    public let towerStatusDire: Int?
    public let towerStatusRadian: Int?
    public let skill: Int?
    public let region: Int?
    public let radiantGoldAdv: [Int]?
    public let radiantXpAdv: [Int]?
    public let players: [Player]
}
