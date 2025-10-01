//
//  GameDataSavingTests.swift
//  D2A
//
//  Created by Shibo Tong on 30/9/2025.
//

import Testing
import CoreData
@testable import D2A

@Suite("Game Data Saving Tests", .serialized) @MainActor
struct GameDataSavingTests {
    let viewContext: NSManagedObjectContext
    let openDotaProvider: OpenDotaProviding
    
    init() {
        viewContext = PersistanceProvider(inMemory: true).mainContext
        openDotaProvider = OpenDotaProvider(network: MockNetwork())
    }
    
    @Test("Save Match Data", arguments: [8479398158])
    func saveMatchData(matchID: Int) async throws {
        let matchData = try await openDotaProvider.match(id: matchID)
        let match = try viewContext.persistent(mapping: matchData, to: Match.self, id: matchID)
        #expect(match.matchID == Int64(matchID))
    }
}
