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
    
    private let syncingLogger: DataSyncingLogger?
    
    private let persistence: PersistenceProviding
    
    init(openDota: OpenDotaFetching = OpenDotaController.shared,
         stratz: StratzFetching = StratzFetcher.shared,
         persistence: PersistenceProviding = PersistenceProvider.shared,
         language: DataLanguageEnum = AppConfig.languageCode,
         logger: Logger = D2ALogger.syncing,
         syncingLogger: DataSyncingLogger? = nil) {
        self.openDota = openDota
        self.stratz = stratz
        self.context = persistence.mainContext.makeContext(author: "Static Data")
        self.persistence = persistence
        self.language = language
        self.logger = logger
        self.syncingLogger = syncingLogger
    }
    
    func startSyncing() async {
        do {
            await withTaskGroup { [weak self] group in
                group.addTask { [weak self] in
                    try? await self?.syncAbilities()
                }
                group.addTask { [weak self] in
                    try? await self?.syncAbilityTranslation()
                }
                group.addTask { [weak self] in
                    try? await self?.syncHeroes()
                }
                group.addTask { [weak self] in
                    try? await self?.syncHeroTranslations()
                }
            }
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
        let syncingLogger = self.syncingLogger
        try await contextSaving(author: "Ability") {
            async let abilityIDAsync = openDota.constants(service: .abilityIDs) as? [String: String]
            async let abilitiesAsync = openDota.constants(service: .abilities) as? [String: Any]
            let (abilityIDs, abilities) = try await (abilityIDAsync, abilitiesAsync)
            guard let abilityIDs, let abilities else {
                throw URLError(.badServerResponse)
            }
            var results: [AbilitySaving] = []
            for (abilityIDString, name) in abilityIDs {
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
                results.append(AbilitySaving(abilityID: abilityID, name: name, data: ability))
            }
            return results
        } saving: { ability, context in
            self.logger.info("Saving ability \(ability.abilityID)")
            try Ability.save(id: ability.abilityID, name: ability.name, data: ability.data, in: context, syncingLogger: syncingLogger)
            try context.save()
        }
    }
    
    private func syncAbilityTranslation() async throws {
        let language = self.language
        try await contextSaving(author: "Ability localization", fetchData: {
            let stratzAbilities = try await stratz.abilities(language: language)
            return stratzAbilities
        }) { ability, context in
            self.logger.info("Saving ability localization \(ability.id)")
            try AbilityTranslation.save(localization: ability, language: language, in: context)
            try context.save()
        }
    }
    
    private func syncHeroes() async throws {
        logger.trace("Start syncing heroes")
        let syncingLogger = self.syncingLogger
        let persistenceProvider = persistence
        try await contextSaving(author: "Hero") {
            guard let heroJSON = try await openDota.constants(service: .heroes) as? [String: Any] else {
                return [HeroSaving]()
            }
            var heroes: [HeroSaving] = []
            for (heroIDString, hero) in heroJSON {
                logger.trace("processing hero: \(heroIDString)")
                guard let heroID = Int(heroIDString) else {
                    logger.error("Hero ID is not an integer: \(heroIDString)")
                    continue
                }
                guard let hero = hero as? [String: Any] else {
                    logger.warning("hero is not valid")
                    continue
                }
                heroes.append(HeroSaving(heroID: heroID, data: hero))
            }
            return heroes
        } saving: { (hero: HeroSaving, context) in
            self.logger.info("Saving hero \(hero.heroID)")
            try persistenceProvider.saveHero(id: hero.heroID, data: hero.data, in: context, logger: syncingLogger)
        }
    }
    
    private func syncHeroTranslations() async throws {
        logger.trace("Start syncing hero translations")
        let language = self.language
        try await contextSaving(author: "Hero Translations") {
            let stratzHeroes = try await stratz.heroes(language: language)
            return stratzHeroes
        } saving: { hero, context in
            self.logger.info("Saving hero translation \(hero.id)")
            try HeroTranslation.save(localization: hero, language: language, in: context)
            try context.save()
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
    
    private struct AbilitySaving {
        let abilityID: Int
        let name: String
        let data: [String: Any]
    }
    
    private struct HeroSaving {
        let heroID: Int
        let data: [String: Any]
    }
}

