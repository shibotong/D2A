//
//  RecentMatchDTO.swift
//  D2A
//
//  Created by Shibo Tong on 9/10/2026.
//

import Foundation
import OpenDota

protocol RecentMatchDTO {
    var matchId: Int { get }
    var playerSlot: Int { get }
    var radiantWin: Bool? { get }
    var duration: Int { get }
    var gameMode: Int { get }
    var lobbyType: Int { get }
    var heroId: Int { get }
    var startTime: Date { get }
    var version: Int? { get }
    var kills: Int { get }
    var deaths: Int { get }
    var assists: Int { get }
    var averageRank: Int? { get }
    var leaverStatus: Int? { get }
    var partySize: Int? { get }
    var heroVariant: Int? { get }
}

extension ODPlayerMatch: RecentMatchDTO { }
