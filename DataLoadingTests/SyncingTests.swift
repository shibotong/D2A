//
//  SyncingTests.swift
//  D2A
//
//  Created by Shibo Tong on 28/3/2026.
//

import Testing
@testable import D2A

struct SyncingTests {
    let logger: DataSyncingLogger
    let service: StaticDataSyncingService
    
    init() {
        self.logger = DataSyncingLogger()
        self.service = StaticDataSyncingService(syncingLogger: logger)
    }
    
    @Test("syncing services")
    func syncingServices() async throws {
        await service.startSyncing()
        let errors = await logger.errors
        #expect(errors.count == 0)
    }
}
