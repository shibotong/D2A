//
//  GameDataFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 1/9/2026.
//

import OpenDota
import Foundation

protocol GameDataFetcher: Sendable {
    func fetchUser(userID: String) async throws -> UserProfileDTO
    func fetchPlayerMatches(userID: String, lastGameDate: Date?) async throws -> [RecentMatchDTO]
}

extension OpenDotaFetcher: GameDataFetcher {
    func fetchUser(userID: String) async throws -> any UserProfileDTO {
        return try await players(accountId: userID)
    }
    
    func fetchPlayerMatches(userID: String, lastGameDate: Date?) async throws -> [any RecentMatchDTO] {
        var days: Double?
        if let lastMatchStartTime = lastGameDate?.timeIntervalSinceNow {
            let oneDay: Double = 60 * 60 * 24
            
            // Decrease 1 sec to avoid adding repeated match
            days = -(lastMatchStartTime + 1) / oneDay
        }
        return try await playerMatches(accountId: userID, days: days)
    }
}
