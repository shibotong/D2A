//
//  SyncingDataTests.swift
//  D2A
//
//  Created by Shibo Tong on 19/4/2026.
//

import Testing
import CoreData
import TestKit
@testable import D2A

@Suite(.serialized)
struct SyncingDataTests {
    let service: StaticDataSyncingService
    let persistance: DataPersistenceService
    let openDotaFetcher: MockOpenDotaFetcher
    
    init() {
        let syncingTimer = MockSyncingTimer()
        openDotaFetcher = MockOpenDotaFetcher()
        let stratzFetcher = MockStratzFetcher()
        persistance = DataPersistenceService.shared
        service = StaticDataSyncingService(
            openDota: openDotaFetcher,
            stratz: stratzFetcher,
            appConfig: MockConfig(),
            syncingTimer: syncingTimer
        )
    }
    
    @Test("Test syncing antimage")
    func testSyncing() async throws {
        try await service.startSyncing()
        let context = PersistenceProvider.shared.mainContext
        let optionalHero = try persistance.fetch(heroID: 1, context: context)
        let hero = try #require(optionalHero)
        
        // Basic Data
        #expect(hero.heroID == 1)
        #expect(hero.name == "npc_dota_hero_antimage")
        #expect(hero.primaryAttr == "agi")
        #expect(hero.attackType == "Melee")
        #expect(hero.baseHealth == 120)
        #expect(hero.baseHealthRegen == 1)
        #expect(hero.baseMana == 75)
        #expect(hero.baseManaRegen == 0)
        #expect(hero.baseArmor == 2)
        #expect(hero.baseMr == 25)
        #expect(hero.baseAttackMin == 29)
        #expect(hero.baseAttackMax == 33)
        #expect(hero.baseStr == 21)
        #expect(hero.baseAgi == 24)
        #expect(hero.baseInt == 12)
        #expect(hero.gainStr == 1.6)
        #expect(hero.gainAgi == 2.8)
        #expect(hero.gainInt == 1.8)
        #expect(hero.attackRange == 150)
        #expect(hero.projectileSpeed == 0)
        #expect(hero.attackRate == 1.4)
        #expect(hero.moveSpeed == 310)
        #expect(hero.turnRate == 0.6)
        #expect(hero.visionDaytimeRange == 1800)
        #expect(hero.visionNighttimeRange == 800)
        #expect(hero.displayName == "Anti-Mage")
        
        // Additional Data
        #expect(hero.roleCarry == 3)
        #expect(hero.roleSupport == 0)
        #expect(hero.roleNuker == 1)
        #expect(hero.roleDisabler == 0)
        #expect(hero.roleJungler == 0)
        #expect(hero.roleDurable == 0)
        #expect(hero.roleEscape == 3)
        #expect(hero.rolePusher == 0)
        #expect(hero.roleInitiator == 0)
        #expect(hero.complexity == 1)
        
        #expect(hero.localizations?.count == 1)
        
        let abilities = try #require(hero.abilities?.array as? [Ability])
        #expect(abilities.map { $0.name } == ["antimage_mana_break", "antimage_blink", "antimage_counterspell", "generic_hidden", "antimage_persectur", "antimage_mana_void"])
        
        let left1Talent = try #require(hero.talent1left)
        #expect(left1Talent.name == "special_bonus_unique_antimage_manavoid_aoe")
        #expect(left1Talent.localizations?.count == 1)
        let l1tLocalization = try #require(left1Talent.localizations?.allObjects.first as? AbilityTranslation)
        #expect(l1tLocalization.displayName == "+200 Mana Void Radius")
        
        let right1Talent = try #require(hero.talent1right)
        #expect(right1Talent.name == "special_bonus_hp_regen_3")
        #expect(right1Talent.localizations?.count == 1)
        let r1tLocalization = try #require(right1Talent.localizations?.allObjects.first as? AbilityTranslation)
        #expect(r1tLocalization.displayName == "+3 Health Regen")
        
        let left2Talent = try #require(hero.talent2left)
        #expect(left2Talent.name == "special_bonus_unique_antimage_6")
        #expect(left2Talent.localizations?.count == 1)
        let l2tLocalization = try #require(left2Talent.localizations?.allObjects.first as? AbilityTranslation)
        #expect(l2tLocalization.displayName == "+0.2 Mana Void Damage Multiplier")
        
        let right2Talent = try #require(hero.talent2right)
        #expect(right2Talent.name == "special_bonus_unique_antimage_5")
        #expect(right2Talent.localizations?.count == 1)
        let r2tLocalization = try #require(right2Talent.localizations?.allObjects.first as? AbilityTranslation)
        #expect(r2tLocalization.displayName == "+9%/18% Persecutor Min/Max Movement Slow")
        
        let left3Talent = try #require(hero.talent3left)
        #expect(left3Talent.name == "special_bonus_unique_antimage_8")
        #expect(left3Talent.localizations?.count == 1)
        let l3tLocalization = try #require(left3Talent.localizations?.allObjects.first as? AbilityTranslation)
        #expect(l3tLocalization.displayName == "+0.8s Mana Void Stun")
        
        let right3Talent = try #require(hero.talent3right)
        #expect(right3Talent.name == "special_bonus_unique_antimage_3")
        #expect(right3Talent.localizations?.count == 1)
        let r3tLocalization = try #require(right3Talent.localizations?.allObjects.first as? AbilityTranslation)
        #expect(r3tLocalization.displayName == "+200 Blink Cast Range")
        
        let left4Talent = try #require(hero.talent4left)
        #expect(left4Talent.name == "special_bonus_unique_antimage_2")
        #expect(left4Talent.localizations?.count == 1)
        let l4tLocalization = try #require(left4Talent.localizations?.allObjects.first as? AbilityTranslation)
        #expect(l4tLocalization.displayName == "-50s Mana Void Cooldown")
        
        let right4Talent = try #require(hero.talent4right)
        #expect(right4Talent.name == "special_bonus_unique_antimage")
        #expect(right4Talent.localizations?.count == 1)
        let r4tLocalization = try #require(right4Talent.localizations?.allObjects.first as? AbilityTranslation)
        #expect(r4tLocalization.displayName == "-{s:bonus_AbilityCooldown}s Blink Cooldown")
    }
}

struct MockSyncingTimer: SyncingTimerProtocol {
    func shouldSync(key: D2A.SyncingTimerKey) -> Bool {
        return true
    }
    
    func finishSyncing(key: SyncingTimerKey) {
        return
    }
}

struct MockConfig: AppConfigProtocol {
    var languageCode: D2A.DataLanguageEnum = .english
    
    var processors: Int = ProcessInfo.processInfo.processorCount
}


