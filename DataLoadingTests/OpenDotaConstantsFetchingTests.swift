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
        let result = try await fetcher.abilities()
        #expect(result.count != 0)
    }
    
    @Test
    func `abilitiy ids`() async throws {
        let result = try await fetcher.abilityIds()
        #expect(result.count != 0)
    }
    
    @Test
    func `aghs desc`() async throws {
        let result = try await fetcher.aghsDesc()
        #expect(result.count != 0)
    }
    
    @Test
    func `hero abilities`() async throws {
        let result = try await fetcher.heroAbilities()
        #expect(result.count != 0)
    }

    @Test
    func `heroes`() async throws {
        let result = try await fetcher.heroes()
        #expect(result.count != 0)
    }
}
