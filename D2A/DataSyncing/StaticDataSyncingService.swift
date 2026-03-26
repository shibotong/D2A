//
//  StaticDataSyncingService.swift
//  D2A
//
//  Created by Shibo Tong on 27/1/2026.
//

import Foundation
import CoreData
import Logging

class StaticDataSyncingService {

    static let shared = StaticDataSyncingService()
    
    private let openDota: OpenDotaFetching
    private let stratz: StratzFetching
    private let language: DataLanguageEnum
    
    /// Private context for saving static data
    private let context: NSManagedObjectContext
    
    private let logger: Logger
    
    private let maxConcurrent = 5
    
    init(openDota: OpenDotaFetching = OpenDotaController.shared,
         stratz: StratzFetching = StratzFetcher.shared,
         persistance: PersistanceProviding = PersistanceController.shared,
         language: DataLanguageEnum = AppConfig.languageCode,
         logger: Logger = D2ALogger.syncing) {
        self.openDota = openDota
        self.stratz = stratz
        self.context = persistance.mainContext.makeContext(author: "Static Data")
        self.language = language
        self.logger = logger
    }
    
    func startSyncing() async {
        do {
//            try await syncAbilities()
            try await syncAbilityTranslation()
//            try await syncHeroes()
            let context = self.context
            try await context.perform {
                try context.save()
            }
            try await context.parent?.perform {
                try context.parent?.save()
            }
        } catch {
            logger.error("Failed to sync data: \(error.localizedDescription)")
        }
    }
    
    private func syncAbilities() async throws {
        logger.trace("Start syncing abilities")
        let abilitySavingContext = context.makeContext(author: "Ability Sync")
        async let abilityIDAsync = openDota.constants(service: .abilityIDs) as? [String: String]
        async let abilitiesAsync = openDota.constants(service: .abilities) as? [String: Any]
        
        let (abilityIDs, abilities) = try await (abilityIDAsync, abilitiesAsync)
        guard let abilityIDs, let abilities else {
            throw URLError(.badServerResponse)
        }
        logger.trace("Finish fetching abilityIDs and abilities from OpenDota")
        for (abilityIDString, name) in abilityIDs {
            logger.trace("processing ability: \(abilityIDString) \(name)")
            guard let ability = abilities[name] as? [String: Any] else {
                logger.info("Not able to find abiilty from data: \(name)")
                continue
            }
            var abilityIDString = abilityIDString
            if abilityIDString == "3060,1617" {
                abilityIDString = "1617"
            }
            guard let abilityID = Int(abilityIDString) else {
                logger.error("Ability ID is not an integer: \(abilityIDString)")
                continue
            }
            let context = abilitySavingContext.makeContext(author: "ability \(abilityID)")
            do {
                try await context.perform {
                    try Ability.save(id: abilityID, name: name, data: ability, in: context)
                    try context.save()
                }
            } catch {
                continue
            }
        }
        try await abilitySavingContext.perform {
            try abilitySavingContext.save()
        }
    }
    
    private func syncAbilityTranslation() async throws {
        let language = self.language
        try await contextSaving(author: "Ability localization", fetchData: {
            let stratzAbilities = try await stratz.abilities(language: language)
            return stratzAbilities
        }) { ability, context in
            self.logger.warning("Start saving \(ability.id)")
            try AbilityTranslation.save(localization: ability, language: language, in: context)
            try context.save()
        }
    }
    
    private func syncHeroes() async throws {
        logger.trace("Start syncing abilities")
        let heroSavingContext = context.makeContext(author: "Hero Sync")
        async let heroesAsync = openDota.constants(service: .heroes) as? [String: Any]
        async let stratzHeroesAsync = stratz.heroes()
        
        let (heroes, localizations) = try await (heroesAsync, stratzHeroesAsync)
        guard let heroes else {
            throw URLError(.badServerResponse)
        }
        var localizationDict: [Int: SKHero] = [:]
        for hero in localizations {
            localizationDict[hero.id] = hero
        }
        logger.trace("Finish fetching heroes from OpenDota")
        for (heroIDString, hero) in heroes {
            logger.trace("processing hero: \(heroIDString)")
            guard let heroID = Int(heroIDString) else {
                logger.error("Hero ID is not an integer: \(heroIDString)")
                continue
            }
            guard let hero = hero as? [String: Any] else {
                logger.warning("hero is not valid")
                continue
            }
            let localization = localizationDict[heroID]
            let context = heroSavingContext.makeContext(author: "hero \(heroID)")
            do {
                try await context.perform {
                    try Hero.save(id: heroID, data: hero, localization: localization, in: context)
                    try context.save()
                }
            } catch {
                continue
            }
        }
        try await heroSavingContext.perform {
            try heroSavingContext.save()
        }
    }
    
    private func contextSaving<T>(
        author: String,
        fetchData: () async throws -> [T],
        saving: @escaping (T, NSManagedObjectContext) throws -> ()
    ) async throws {
        let maxConcurrent = self.maxConcurrent
        let savingContext = context.makeContext(author: author)
        let results = try await fetchData()
        await withTaskGroup { group in
            var iterator = results.makeIterator()
            for _ in 0..<maxConcurrent {
                if let item = iterator.next() {
                    group.addTask {
                        let context = savingContext.makeContext()
                        await context.perform {
                            try? saving(item, context)
                            try? context.save()
                        }
                    }
                }
            }
            
            while let _ = await group.next() {
                if let item = iterator.next() {
                    group.addTask {
                        let context = savingContext.makeContext()
                        await context.perform {
                            try? saving(item, context)
                            try? context.save()
                        }
                    }
                }
            }
        }
        try await savingContext.perform {
            try savingContext.save()
        }
    }
}
