//
//  GameDataTests.swift
//  D2A
//
//  Created by Shibo Tong on 29/9/2025.
//

import Testing
@testable import D2A

@Suite("Game Data Loading Tests")
struct GameDataTests {
    
    let gameDataController: GameDataController
    let persistanceProvider: PersistanceProvider
    
    init() {
        persistanceProvider = PersistanceProvider(inMemory: true)
        let openDotaProvider = OpenDotaProvider(network: MockNetwork())
        gameDataController = GameDataController(persistanceProvider: persistanceProvider, openDotaProvider: openDotaProvider)
    }
    
    @Test("Test Saving Match", arguments: [8479398158])
    func testSavingMatch(matchID: Int) async throws {
        let context = persistanceProvider.makeContext(author: "match")
        let match = try await gameDataController.loadMatch(matchID: matchID)
        #expect(match.matchID == Int64(matchID))
        #expect(match.version == Int16(22))
    }
}
