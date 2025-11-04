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

    let matchID: String

    convenience init(match: RecentMatchCodable) {
        self.init(
            isWin: match.playerWin,
            heroID: match.heroID,
            kills: match.kills,
            deaths: match.deaths,
            assists: match.assists,
            partySize: match.partySize,
            gameMode: match.gameMode?.modeName ?? "Unknown",
            lobbyName: match.gameLobby.lobbyName,
            startTime: Date.init(timeIntervalSince1970: TimeInterval(match.startTime)),
            matchID: match.id.description)
    }

    convenience init(match: RecentMatch) {
        self.init(
            isWin: match.playerWin,
            heroID: Int(match.heroID),
            kills: Int(match.kills),
            deaths: Int(match.deaths),
            assists: Int(match.assists),
            partySize: Int(match.partySize),
            gameMode: match.gameMode?.modeName ?? "Unknown",
            lobbyName: match.gameLobby.lobbyName,
            startTime: match.startTime ?? Date(),
            matchID: match.matchID.description)
    }

    convenience init(match: D2AWidgetMatch) {
        self.init(
            isWin: match.win,
            heroID: match.heroID,
            kills: match.kills,
            deaths: match.deaths,
            assists: match.assists,
            partySize: match.partySize,
            gameMode: match.gameMode?.modeName ?? "Unknown",
            lobbyName: match.lobby.lobbyName,
            startTime: match.startTime ?? Date(),
            matchID: match.id)
    }

    init(
        isWin: Bool,
        heroID: Int,
        kills: Int,
        deaths: Int,
        assists: Int,
        partySize: Int?,
        gameMode: String,
        lobbyName: String,
        startTime: Date = Date(),
        matchID: String = "0"
    ) {
        self.isWin = isWin
        self.heroID = heroID

        self.kills = kills
        self.deaths = deaths
        self.assists = assists

        self.partySize = partySize

        self.gameMode = gameMode
        self.gameLobby = lobbyName
        self.startTime = startTime
        self.matchID = matchID
    }
}
