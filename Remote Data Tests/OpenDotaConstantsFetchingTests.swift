//
//  OpenDotaConstantsFetchingTests.swift
//  Unit Tests
//
//  Created by Shibo Tong on 24/3/2026.
//

import Testing
@testable import OpenDota

struct RemoteOpenDotaConstantsTests {
    
    let fetcher: OpenDotaConstantFetcher
    
    init() {
        fetcher = OpenDotaConstantFetcher()
    }

    @Test
    func `heroes`() async {
        await #expect(throws: Never.self) {
            try await fetcher.heroes()
        }
    }
    
    @Test
    func `abilities`() async throws {
        await #expect(throws: Never.self) {
            try await fetcher.abilities()
        }
    }
    
    @Test
    func `hero abilities`() async throws {
        await #expect(throws: Never.self) {
            try await fetcher.heroAbilities()
        }
    }
    
    @Test
    func `ability IDs`() async throws {
        await #expect(throws: Never.self) {
            try await fetcher.abilityIDs()
        }
    }
}
