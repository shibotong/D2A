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
    public let radiantWin: Bool
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
    public let leaverStatus: Int
    public let partySize: Int?
    public let heroVariant: Int?
}
