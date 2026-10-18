//
//  MockGameDataFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 13/10/2026.
//

@testable import D2A
import Foundation

class MockGameDataFetcher: GameDataFetcher {
    
    var fetchUserResult: UserProfileDTO!
    var fetchUserCount = 0
    var fetchUserClosure: ((String) async throws -> any D2A.UserProfileDTO)?
    
    func fetchUser(userID: String) async throws -> any D2A.UserProfileDTO {
        fetchUserCount += 1
        if let fetchUserClosure {
            return try await fetchUserClosure(userID)
        }
        return fetchUserResult
    }
    
    var fetchPlayerMatchesResult: [any RecentMatchDTO]!
    var fetchPlayerMatchesCount = 0
    var fetchPlayerMatchesClosure: ((String, Date?) async throws -> [any RecentMatchDTO])?
    
    func fetchPlayerMatches(userID: String, lastGameDate: Date?) async throws -> [any D2A.RecentMatchDTO] {
        fetchPlayerMatchesCount += 1
        if let fetchPlayerMatchesClosure {
            return try await fetchPlayerMatchesClosure(userID, lastGameDate)
        }
        return fetchPlayerMatchesResult
    }
}
