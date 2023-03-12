//
//  MatchListRowViewModel.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import UIKit

class MatchListRowViewModel: ObservableObject {
    let isWin: Bool
    let heroID: Int
    
    let kills: Int
    let deaths: Int
    let assists: Int
    
    let gameMode: String
    
    let partySize: Int?
    
    let gameLobby: String
    let startTime: Date?
    
    init(match: RecentMatchCodable) {
        isWin = match.playerWin
        heroID = match.heroID
        kills = match.kills
        deaths = match.deaths
        assists = match.assists
        gameMode = match.gameMode.modeName
        partySize = match.partySize
        gameLobby = match.gameLobby.lobbyName
        startTime = Date.init(timeIntervalSince1970: TimeInterval(match.startTime))
    }
    
    init(match: RecentMatch) {
        isWin = match.playerWin
        heroID = Int(match.heroID)
        kills = Int(match.kills)
        deaths = Int(match.deaths)
        assists = Int(match.assists)
        gameMode = match.gameMode.modeName
        partySize = Int(match.partySize)
        gameLobby = match.gameLobby.lobbyName
        startTime = match.startTime
    }
    
    init(isWin: Bool,
         heroID: Int,
         kills: Int,
         deaths: Int,
         assists: Int,
         partySize: Int?,
         gameMode: String,
         lobbyName: String,
         startTime: Date = Date()) {
        self.isWin = isWin
        self.heroID = heroID
        
        self.kills = kills
        self.deaths = deaths
        self.assists = assists
        
        self.partySize = partySize
        
        self.gameMode = gameMode
        self.gameLobby = lobbyName
        self.startTime = startTime
    }
}
