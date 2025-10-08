//
//  MatchSavingTests.swift
//  D2A
//
//  Created by Shibo Tong on 30/9/2025.
//

import Testing
import CoreData
@testable import D2A

@Suite("Match Saving Tests", .serialized) @MainActor
struct MatchSavingTests {
    let viewContext: NSManagedObjectContext
    let openDotaProvider: OpenDotaProviding
    
    init() {
        viewContext = PersistanceProvider.shared.mainContext
        openDotaProvider = OpenDotaProvider()
    }
    
    @Test("Save Match Data", arguments: [7434967285])
    func saveMatchData(matchID: Int) async throws {
        let matchData = try await openDotaProvider.match(id: matchID)
        let match = try viewContext.persistent(mapping: matchData, to: Match.self, id: matchID)
        #expect(match.matchID == Int64(matchID))
    }
}
