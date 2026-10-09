//
//  GameDataFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 1/9/2026.
//

import OpenDota

protocol GameDataFetcher: Sendable {
    func fetchUser(userID: String) async throws -> UserProfileDTO
    func fetchPlayerMatches(userID: String, days: Double?) async throws -> [RecentMatchDTO]
}

extension OpenDotaFetcher: GameDataFetcher {
    func fetchUser(userID: String) async throws -> any UserProfileDTO {
        return try await players(accountId: userID)
    }
    
    func fetchPlayerMatches(userID: String, days: Double?) async throws -> [any RecentMatchDTO] {
        return try await playerMatches(accountId: userID, days: days)
    }
}
