//
//  OpenDotaFetcherTests.swift
//  D2A
//
//  Created by Shibo Tong on 20/5/2026.
//

import Testing
import TestKit
import Foundation
@testable import OpenDota

struct OpenDotaFetcherTests {
    
    let fetcher: OpenDotaFetcher
    let client: MockAPIClient
    let fileReader: FileReader
    
    init() {
        client = MockAPIClient()
        fetcher = OpenDotaFetcher(apiClient: client)
        fileReader = FileReader.shared
    }
    
    @Test("Test hero api")
    func heroesData() async throws {
        client.getReturnValue = try fileReader.readFile("heroes")
        let result = try await fetcher.heroes()
        #expect(result.count == 127)
    }
    
    @Test("Test abilities api")
    func abilitiesData() async throws {
        client.getReturnValue = try fileReader.readFile("abilities")
        let result = try await fetcher.abilities()
        #expect(result.count == 3084)
    }
    
    @Test("Test hero_abilities api")
    func heroAbilitiesData() async throws {
        client.getReturnValue = try fileReader.readFile("hero_abilities")
        let result = try await fetcher.heroAbilities()
        #expect(result.count == 127)
    }
    
    @Test("Test ability_ids api")
    func abilityIDsData() async throws {
        client.getReturnValue = try fileReader.readFile("ability_ids")
        let result = try await fetcher.abilityIDs()
        #expect(result.count == 3150)
    }
    
    @Test("Test yatoro user profile")
    func profile() async throws {
        client.getReturnValue = try fileReader.readFile("player_yatoro")
        let user = try await fetcher.profile(id: "321580662")
        let profile = user.profile
        #expect(user.rankTier == 80)
        #expect(user.leaderboardRank == 12)
        #expect(user.computedMmr == nil)
        #expect(user.computedMmrTurbo == nil)
        #expect(profile.accountId == 321580662)
    }
    
    @Test("Test match")
    func match() async throws {
        client.getReturnValue = try fileReader.readFile("match_8671593880")
        let match = try await fetcher.match(id: "8671593880")
        #expect(match.gameMode == 22)
        #expect(match.matchId == 8671593880)
    }
}
