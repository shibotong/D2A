//
//  SyncingTimerTests.swift
//  D2A
//
//  Created by Shibo Tong on 16/4/2026.
//

import Testing
@testable import D2A
import Foundation

struct SyncingTimerTests {
    
    @Test
    func `should sync when no date set`() {
        let syncingTimer = SyncingTimer()
        let shouldSync = syncingTimer.shouldSync(key: .constants)
        #expect(shouldSync == true)
    }
    
    @Test
    func `should sync when date set to yesterday`() {
        let syncingTimer = SyncingTimer {
            let date = Date()
            return date.addingTimeInterval(-24 * 60 * 60)
        }
        syncingTimer.finishSyncing(key: .constants)
        let shouldSync = syncingTimer.shouldSync(key: .constants)
        #expect(shouldSync == true)
    }
    
    @Test
    func `should not sync when date set to today`() {
        let syncingTimer = SyncingTimer()
        syncingTimer.finishSyncing(key: .constants)
        let shouldSync = syncingTimer.shouldSync(key: .constants)
        #expect(shouldSync == false)
    }
}
