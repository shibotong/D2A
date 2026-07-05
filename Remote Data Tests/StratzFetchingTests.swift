//
//  StratzFetchingTests.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

import Testing
@testable import Stratz

struct StratzFetchingTests {
    
    let fetcher: StratzFetcher
    
    init() {
        fetcher = StratzFetcher()
    }

    @Test
    func `heroes`() async throws {
        let result = try await fetcher.heroes(language: .english)
        #expect(result.count != 0)
    }
    
    @Test
    func `abilities`() async throws {
        let result = try await fetcher.abilities(language: .english)
        #expect(result.count != 0)
    }
}
