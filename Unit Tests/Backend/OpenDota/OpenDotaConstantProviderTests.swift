//
//  OpenDotaConstantProviderTests.swift
//  Unit Tests
//
//  Created by Shibo Tong on 22/7/2025.
//

import Testing
@testable import D2A

@Suite("OpenDotaConstantProvider tests")
struct OpenDotaConstantProviderTests {
    
    let provider: OpenDotaConstantProvider
    
    init() {
        let fetcher = PreviewDataProvider()
        provider = OpenDotaConstantProvider(fetcher: fetcher)
    }
    
    
    @Test("Ability exists")
    func abilityExists() async throws {
        #expect(try await provider.loadAbilities().count > 0, "Provider should return abilities")
    }
    
    @Test("Hero exists")
    func heroExists() async throws {
        #expect(try await provider.loadHeroes().count > 0, "Provider should return heroes")
    }
    
    @Test("Game modes exists")
    func modeExists() async throws {
        #expect(try await provider.loadGameModes().count > 0, "Provider should return game modes")
    }
    
}
