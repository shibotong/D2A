//
//  OpenDotaConstantsFetchingTests.swift
//  Unit Tests
//
//  Created by Shibo Tong on 24/3/2026.
//

import Testing
@testable import OpenDota

struct OpenDotaConstantsFetchingTests {
    
    let fetcher: OpenDotaConstantFetcher
    
    init() {
        fetcher = OpenDotaConstantFetcher()
    }

    @Test
    func `heroes`() async throws {
        let result = try await fetcher.heroes()
        #expect(result.count != 0)
    }
}
