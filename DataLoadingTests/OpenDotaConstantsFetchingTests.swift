//
//  OpenDotaConstantsFetchingTests.swift
//  Unit Tests
//
//  Created by Shibo Tong on 24/3/2026.
//

import Testing
@testable import D2A

struct OpenDotaConstantsFetchingTests {
    
    let fetcher: OpenDotaConstantFetcher
    
    init() {
        fetcher = OpenDotaConstantFetcher()
    }
    
    @Test
    func `abilities`() async throws {
        let dict = try await fetcher.abilities()
        #expect(dict.count != 0)
    }
    
    @Test
    func `abilitiy ids`() async throws {
        let dict = try await fetcher.abilityIds()
        #expect(dict.count != 0)
    }

    @Test
    func `heroes`() async throws {
        let dict = try await fetcher.heroes()
        #expect(dict.count != 0)
    }
}
