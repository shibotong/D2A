//
//  StaticDataSyncingService.swift
//  D2A
//
//  Created by Shibo Tong on 27/1/2026.
//

import Foundation
import CoreData
import Logging

class StaticDataSyncingService: ObservableObject {

    static let shared = StaticDataSyncingService()
    
    @Published var isCompleted: Bool = true
    
    private let openDota: OpenDotaFetching
    private let stratz: StratzFetching
    private let language: DataLanguageEnum
    
    /// Private context for saving static data
    private let context: NSManagedObjectContext
    
    private let logger: Logger
    
    private let maxConcurrent = 4
    
    private let syncingLogger: DataSyncingLogger?
    
    private let persistence: PersistenceProviding
    private let notification: D2ANotification
    
    private let syncingTimer: SyncingTimerProtocol
    
    init(openDota: OpenDotaFetching = OpenDotaController.shared,
         stratz: StratzFetching = StratzFetcher.shared,
         persistence: PersistenceProviding = PersistenceProvider.shared,
         language: DataLanguageEnum = AppConfig.languageCode,
         logger: Logger = D2ALogger.syncing,
         notification: D2ANotification = .default,
         syncingLogger: DataSyncingLogger? = nil,
         syncingTimer: SyncingTimerProtocol = SyncingTimer()) {
        self.openDota = openDota
        self.stratz = stratz
        self.context = persistence.mainContext.makeContext(author: "Static Data")
        self.persistence = persistence
        self.language = language
        self.logger = logger
        self.notification = notification
        self.syncingLogger = syncingLogger
        self.syncingTimer = syncingTimer
    }
    
    func startSyncing() async throws {
        isCompleted = false
        let shouldSyncConstants = syncingTimer.shouldSync(key: .constants)
        let shouldSyncLocalization = syncingTimer.shouldSync(key: .localization(language))
        logger.info("Should sync constants: \(shouldSyncConstants)")
        if shouldSyncConstants {
            try await syncAbilities()
            try await syncHeroes()
        }
        if shouldSyncLocalization {
            try await syncAbilityTranslation()
            try await syncHeroTranslations()
        }
        let context = self.context
        try await context.perform {
            try context.save()
        }
        try await context.parent?.perform {
            try context.parent?.save()
        }
        notification.syncingCompletion.send(true)
        if shouldSyncConstants {
            syncingTimer.finishSyncing(key: .constants)
        }
        if shouldSyncLocalization {
            syncingTimer.finishSyncing(key: .localization(language))
        }
        isCompleted = true
    }
    
    private func syncAbilities() async throws {
        logger.trace("Start syncing abilities")
        let syncingLogger = self.syncingLogger
        let persistence = self.persistence
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
                    logger.trace("Not able to find abiilty from data: \(name)")
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
            self.logger.trace("Saving ability \(ability.abilityID)")
            try persistence.save(abilityID: ability.abilityID, name: ability.name, data: ability.data, in: context, syncingLogger: syncingLogger)
            try context.save()
        }
    }
    
    private func syncAbilityTranslation() async throws {
        let language = self.language
        let persistence = self.persistence
        try await contextSaving(author: "Ability localization", fetchData: {
            let stratzAbilities = try await stratz.abilities(language: language)
            return stratzAbilities
        }) { ability, context in
            self.logger.trace("Saving ability localization \(ability.id)")
            try persistence.save(ability: ability, language: language, in: context)
            try context.save()
        }
    }
    
    private func syncHeroes() async throws {
        logger.trace("Start syncing heroes")
        let syncingLogger = self.syncingLogger
        let persistenceProvider = persistence
        try await contextSaving(author: "Hero") {
            guard let heroJSON = try await openDota.constants(service: .heroes) as? [String: Any] else {
                return [HeroRecipe]()
            }
            guard let abilitiesJSON = try await openDota.constants(service: .heroAbilities) as? [String: Any] else {
                return [HeroRecipe]()
            }
            let heroAdditionalDatas = try await stratz.heroAdditionalData()
            var heroes: [HeroRecipe] = []
            for heroAdditionalData in heroAdditionalDatas {
                guard let heroData = heroJSON["\(heroAdditionalData.heroID)"] as? [String: Any], let abilities = abilitiesJSON[heroAdditionalData.name] as? [String: Any] else {
                    logger.warning("hero is not valid")
                    continue
                }
                heroes.append(HeroRecipe(heroID: heroAdditionalData.heroID, data: heroData, abilities: abilities, additonalData: heroAdditionalData))
            }
            return heroes
        } saving: { (hero: HeroRecipe, context) in
            self.logger.trace("Saving hero \(hero.heroID)")
            try persistenceProvider.save(hero: hero, in: context, logger: syncingLogger)
        }
    }
    
    private func syncHeroTranslations() async throws {
        logger.trace("Start syncing hero translations")
        let persistence = self.persistence
        let language = self.language
        try await contextSaving(author: "Hero Translations") {
            let stratzHeroes = try await stratz.heroes(language: language)
            return stratzHeroes
        } saving: { hero, context in
            self.logger.trace("Saving hero translation \(hero.id)")
            try persistence.save(hero: hero, language: language, in: context)
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
}

