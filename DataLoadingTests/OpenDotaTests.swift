//
//  OpenDotaTests.swift
//  DataLoadingTests
//
//  Created by Shibo Tong on 17/8/2025.
//

import Testing
@testable import D2A

struct OpenDotaTests {

    let provider = OpenDotaProvider()
    
    @Test
    func proPlayers() async throws {
        let players = try await provider.proUsers()
        #expect(players.count > 0)
        let firstLogin = try #require(players[0].lastLogin)
        let secondLogin = try #require(players[1].lastLogin)
        #expect(firstLogin > secondLogin)
    }

}
