//
//  StaticDataSyncingTests.swift
//  D2A
//
//  Created by Shibo Tong on 28/1/2026.
//

import Testing
@testable import D2A

struct StaticDataSyncingTests {
    let service = StaticDataSyncingService(persistance: PersistanceController(inMemory: true))
    
    @Test("syncing services")
    func syncingServices() async throws {
        await service.startSyncing()
    }
}
