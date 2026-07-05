//
//  RemoteOpenDotaFetcherTests.swift
//  Unit Tests
//
//  Created by Shibo Tong on 24/3/2026.
//

import Testing
import Foundation
@testable import OpenDota

struct RemoteOpenDotaFetcherTests {
    
    let fetcher: OpenDotaFetcher
    
    init() {
        fetcher = OpenDotaFetcher()
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
    
    @Test
    func `Yatoro profile`() async {
        await #expect(throws: Never.self) {
            let _ = try await fetcher.profile(id: "321580662")
        }
    }
    
    @Test
    func `Not Found Profiles`() async {
        await #expect(throws: URLError.notFound) {
            let _ = try await fetcher.profile(id: "123123131")
        }
    }
}
