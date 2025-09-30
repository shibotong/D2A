//
//  GameDataTests.swift
//  D2A
//
//  Created by Shibo Tong on 29/9/2025.
//

import Testing
import CoreData
@testable import D2A

@Suite("Game Data Loading Tests")
struct GameDataTests {
    
    let persistanceProvider: PersistanceProvider
    let openDotaProvider: OpenDotaProviding
    
    init() {
        persistanceProvider = PersistanceProvider(inMemory: true)
        openDotaProvider = OpenDotaProvider(network: MockNetwork())
    }
    
    @Test("Test Saving Match", arguments: [8479398158])
    func testSavingMatch(matchID: Int) async throws {
        let matchData = try await openDotaProvider.match(id: matchID)
        let context = persistanceProvider.makeContext(author: "match")
        let match = try context.persistent(mapping: matchData, to: Match.self, id: matchID)
        #expect(match.matchID == Int64(matchID))
        #expect(match.version == Int16(22))
    }
}
