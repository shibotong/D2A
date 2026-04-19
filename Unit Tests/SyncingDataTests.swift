//
//  SyncingDataTests.swift
//  D2A
//
//  Created by Shibo Tong on 19/4/2026.
//

import Testing
import CoreData
@testable import D2A

@Suite(.serialized)
struct SyncingDataTests {
    let service: StaticDataSyncingService
    let persistance: PersistenceProvider
    let openDotaFetcher: MockOpenDotaFetcher
    
    init() {
        let syncingTimer = MockSyncingTimer()
        openDotaFetcher = MockOpenDotaFetcher()
        let stratzFetcher = MockStratzFetcher()
        persistance = PersistenceProvider.shared
        service = StaticDataSyncingService(
            openDota: openDotaFetcher,
            stratz: stratzFetcher,
            language: .english,
            syncingTimer: syncingTimer
        )
    }
    
    @Test("Test syncing antimage")
    func testSyncing() async throws {
        await service.startSyncing()
        let context = persistance.mainContext
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


