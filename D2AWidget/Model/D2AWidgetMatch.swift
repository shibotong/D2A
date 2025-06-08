//
//  D2AWidgetMatch.swift
//  D2A
//
//  Created by Shibo Tong on 26/1/2024.
//

import Foundation
import UIKit

struct D2AWidgetMatch: Identifiable {
    let id: String
    let heroID: Int
    let win: Bool
    
    let kills: Int
    let deaths: Int
    let assists: Int
    
    let partySize: Int?
    
    let startTime: Date?
    let lobby: LobbyType
    let gameMode: GameMode
    
    init(_ match: RecentMatch) {
        self.init(matchID: match.id ?? "0",
                  heroID: Int(match.heroID),
                  win: match.playerWin,
                  kills: Int(match.kills),
                  deaths: Int(match.deaths),
                  assists: Int(match.assists),
                  partySize: Int(match.partySize),
                  startTime: match.startTime,
                  lobby: match.gameLobby,
                  gameMode: match.gameMode)
    }
    
    init(matchID: String,
         heroID: Int,
         win: Bool,
         kills: Int = 0,
         deaths: Int = 0,
         assists: Int = 0,
         partySize: Int = 0,
         startTime: Date? = nil,
         lobby: LobbyType = .init(id: 1, name: "lobby"),
         gameMode: GameMode = .init(id: 1, name: "mode")) {
        id = matchID
        self.heroID = heroID
        self.win = win
        self.kills = kills
        self.deaths = deaths
        self.assists = assists
        self.startTime = startTime
        self.lobby = lobby
        self.partySize = partySize
        self.gameMode = gameMode
    }
}
