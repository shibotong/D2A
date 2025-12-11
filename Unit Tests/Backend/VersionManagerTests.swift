//
//  VersionManagerTests.swift
//  D2A
//
//  Created by Shibo Tong on 11/12/2025.
//

import Testing
@testable import D2A

struct VersionManagerTests {
    
    @Test("Test update")
    func versionUpdate() {
        let manager = VersionManager(lastVersion: "1.0.0", appVersion: "1.1.1")
        #expect(manager.isNewInstalled == false)
        #expect(manager.isUpdated == true)
    }
    
    @Test("Test newly installed")
    func newlyInstalled() {
        let manager = VersionManager(lastVersion: nil, appVersion: "1.1.1")
        #expect(manager.isNewInstalled == true)
        #expect(manager.isUpdated == false)
    }
    
    @Test("Test not updated")
    func noChange() {
        let manager = VersionManager(lastVersion: "1.1.1", appVersion: "1.1.1")
        #expect(manager.isNewInstalled == false)
        #expect(manager.isUpdated == false)
    }
    
}
