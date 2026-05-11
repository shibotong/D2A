//
//  SyncingTimerTests.swift
//  D2A
//
//  Created by Shibo Tong on 16/4/2026.
//

import Testing
@testable import D2A
import Foundation

class MockUserDefaults: UserDefaults {
    var persistedValue: Date? = nil
        
    override func set(_ value: Any?, forKey defaultName: String) {
        persistedValue = value as? Date
    }
    
    override func value(forKey key: String) -> Any? {
        return persistedValue
    }
}

class SyncingTimerTests {
    
    let userDefaults: UserDefaults
    
    init() {
        userDefaults = MockUserDefaults()
    }
    
    @Test
    func `should sync when no date set`() {
        let syncingTimer = SyncingTimer(userDefaults: userDefaults)
        let shouldSync = syncingTimer.shouldSync(key: .constants)
        #expect(shouldSync == true)
    }
    
    @Test
    func `should sync when date set to yesterday`() {
        let syncingTimer = SyncingTimer(userDefaults: userDefaults) {
            let date = Date()
            return date.addingTimeInterval(-24 * 60 * 60)
        }
        syncingTimer.finishSyncing(key: .constants)
        let shouldSync = syncingTimer.shouldSync(key: .constants)
        #expect(shouldSync == true)
    }
    
    @Test
    func `should not sync when date set to today`() {
        let syncingTimer = SyncingTimer(userDefaults: userDefaults)
        syncingTimer.finishSyncing(key: .constants)
        let shouldSync = syncingTimer.shouldSync(key: .constants)
        #expect(shouldSync == false)
    }
}
