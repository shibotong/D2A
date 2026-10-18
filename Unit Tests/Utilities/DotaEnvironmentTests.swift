//
//  DotaEnvironmentTests.swift
//  D2A
//
//  Created by Codex on 18/10/2026.
//

import Foundation
import Testing
@testable import D2A

@MainActor
struct DotaEnvironmentTests {
    @Test
    func `subscription status is loaded from injected user defaults`() throws {
        let userDefaults = try makeUserDefaults()
        defer { clear(userDefaults) }
        userDefaults.set(true, forKey: .purchaseKey)

        let environment = DotaEnvironment(
            imageProvider: MockImageProvider(),
            userDefaults: userDefaults,
            notification: D2ANotification()
        )

        #expect(environment.subscriptionStatus)
    }

    private func makeUserDefaults() throws -> UserDefaults {
        try #require(UserDefaults(suiteName: "DotaEnvironmentTests.\(UUID().uuidString)"))
    }

    private func clear(_ userDefaults: UserDefaults) {
        for key in userDefaults.dictionaryRepresentation().keys {
            userDefaults.removeObject(forKey: key)
        }
    }
}
