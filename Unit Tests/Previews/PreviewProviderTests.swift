//
//  PreviewProviderTests.swift
//  D2A
//
//  Created by Shibo Tong on 20/7/2025.
//

import Testing
@testable import D2A

let provider = PreviewDataProvider()

@Test
func testPreviewProvider() {
    let abilities = loadService(service: .abilities, as: [String: ODAbility].self)
    #expect(abilities?.count != 0, "abilities should not be empty")
    let abilityIDs = loadService(service: .abilityIDs, as: [String: String].self)
    #expect(abilityIDs?.count != 0, "ability IDs should not be empty")
    let heroes = loadService(service: .heroes, as: [String: ODHero].self)
    #expect(heroes?.count != 0, "heroes should not be empty")
    
    let heroLore = loadService(service: .heroLore, as: [String: String].self)
    #expect(heroLore?.count != 0, "hero lore should not be empty")
}

func loadService<T: Decodable>(service: OpenDotaConstantService, as type: T.Type) -> T? {
    return provider.loadOpenDotaConstants(service: service, as: type)
@Suite("PreviewDataProvider tests")
struct PreviewProviderTests {
    let provider = PreviewDataProvider()
    
    @Test("abilities")
    func abilities() {
        let abilities = provider.loadOpenDotaConstants(service: .abilities, as: [String: ODAbility].self) ?? [:]
        #expect(abilities.count > 0, "abilities should not be empty")
    }
    
    @Test("abilityIDs")
    func abilityIDs() {
        let abilityIDs = provider.loadOpenDotaConstants(service: .abilityIDs, as: [String: String].self) ?? [:]
        #expect(abilityIDs.count > 0, "ability IDs should not be empty")
    }
    
    @Test("heroes")
    func heroes() {
        let heroes = provider.loadOpenDotaConstants(service: .heroes, as: [String: ODHero].self) ?? [:]
        #expect(heroes.count > 0, "heroes should not be empty")
    }
    
    @Test("hero abilities")
    func heroAbilities() {
        let heroAbilities = provider.loadOpenDotaConstants(service: .heroAbilities, as: [String: ODHeroAbilities].self) ?? [:]
        #expect(heroAbilities.count > 0, "hero abilities should not be empty")
    }
}
