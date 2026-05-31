//
//  StaticDataSyncingService.swift
//  D2A
//
//  Created by Shibo Tong on 27/1/2026.
//

import Foundation
import CoreData
import Logging
import OpenDota
import Stratz

class StaticDataSyncingService: ObservableObject {

    static let shared = StaticDataSyncingService()
    @Published var isCompleted = false
    @Published var currentProcess = 0
    @Published var syncingProgress: Double = 0.0
    
    let totalProcesses = 4
    
    @Published var useV2 = true
    
    private let openDota: OpenDotaConstantFetching
    private let stratz: StratzFetching
    private let language: DataLanguageEnum
    
    /// Private context for saving static data
    private let context: NSManagedObjectContext
    
    private let logger: Logger
    
    private let maxConcurrent: Int
    
    private let persistence: DataPersistenceService
    private let notification: D2ANotification
    
    private let syncingTimer: SyncingTimerProtocol
    
    private var syncingActor: SyncingProgress = SyncingProgress()
    
    init(openDota: OpenDotaConstantFetching = OpenDotaConstantFetcher.shared,
         stratz: StratzFetching = StratzFetcher.shared,
         mainContext: NSManagedObjectContext = PersistenceProvider.shared.mainContext,
         persistenceService: DataPersistenceService = .shared,
         appConfig: AppConfigProtocol = AppConfig.shared,
         logger: Logger = D2ALogger.syncing,
         notification: D2ANotification = .default,
         syncingTimer: SyncingTimerProtocol = SyncingTimer.shared) {
        self.openDota = openDota
        self.stratz = stratz
        self.context = mainContext.makeContext(author: "Static Data")
        self.persistence = persistenceService
        self.language = appConfig.languageCode
        self.maxConcurrent = appConfig.processors
        self.logger = logger
        self.notification = notification
        self.syncingTimer = syncingTimer
    }
    
    func startSyncing() async throws {
        defer {
            isCompleted = true
        }
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
    }
    
    private func syncAbilities() async throws {
        logger.trace("Start syncing abilities")
        let persistence = self.persistence
        try await contextSaving(author: "Ability") {
            async let abilityIDAsync = openDota.abilityIDs()
            async let abilitiesAsync = openDota.abilities()
            let (abilityIDs, abilities) = try await (abilityIDAsync, abilitiesAsync)
            return persistence.sortAbilities(abilityIDs: abilityIDs, abilities: abilities)
        } saving: { ability, context in
            self.logger.trace("Saving ability \(ability.abilityID)")
            try persistence.save(abilityID: ability.abilityID, name: ability.name, data: ability.data, in: context)
            try context.save()
        }
    }
    
    private func syncAbilityTranslation() async throws {
        let language = self.language
        let persistence = self.persistence
        try await contextSaving(author: "Ability localization", fetchData: {
            let stratzAbilities = try await stratz.abilities(language: language.language)
            return stratzAbilities
        }) { ability, context in
            self.logger.trace("Saving ability localization \(ability.id)")
            try persistence.save(ability: ability, language: language, in: context)
            try context.save()
        }
    }
    
    private func syncHeroes() async throws {
        logger.trace("Start syncing heroes")
        let persistenceProvider = persistence
        try await contextSaving(author: "Hero") {
            async let heroesAsync = openDota.heroes()
            async let abilitiesAsync = openDota.heroAbilities()
            async let heroAdditionalDatasAsync = stratz.heroAdditionalData()
            let (heroJSON, abilitiesJSON, heroAdditionalDatas) = try await (heroesAsync, abilitiesAsync, heroAdditionalDatasAsync)
            return persistence.sortHeroes(heroJSON: heroJSON, abilitiesJSON: abilitiesJSON, heroAdditionalDatas: heroAdditionalDatas)
        } saving: { (hero: HeroRecipe, context) in
            self.logger.trace("Saving hero \(hero.heroID)")
            try persistenceProvider.save(hero: hero, in: context)
        }
    }
    
    private func syncHeroTranslations() async throws {
        logger.trace("Start syncing hero translations")
        let persistence = self.persistence
        let language = self.language
        try await contextSaving(author: "Hero Translations") {
            let stratzHeroes = try await stratz.heroes(language: language.language)
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
        if useV2 {
            try await contextSavingV2(author: author, fetchData: fetchData, saving: saving)
        } else {
            try await contextSavingV1(author: author, fetchData: fetchData, saving: saving)
        }
    }
    
    private func contextSavingV1<T>(
        author: String,
        fetchData: () async throws -> [T],
        saving: @escaping (T, NSManagedObjectContext) throws -> ()
    ) async throws {
        let maxConcurrent = self.maxConcurrent
        let savingContext = context.makeContext(author: author)
        let results = try await fetchData()
        updateSyncingProgress(name: author, total: results.count)
        await withTaskGroup { [weak self] group in
            var iterator = results.makeIterator()
            for _ in 0..<maxConcurrent {
                if let item = iterator.next() {
                    group.addTask {
                        let context = savingContext.makeContext()
                        self?.updateSyncingProgress(updateCurrent: true)
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
                        self?.updateSyncingProgress(updateCurrent: true)
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
    
    private func contextSavingV2<T>(
        author: String,
        fetchData: () async throws -> [T],
        saving: @escaping (T, NSManagedObjectContext) throws -> ()
    ) async throws {
        let maxConcurrent = self.maxConcurrent
        let savingContext = context.makeContext(author: author)
        let results = try await fetchData()
        updateSyncingProgress(name: author, total: results.count)
        let resultsCount = results.count
        var itemsForEachArray = resultsCount / maxConcurrent
        if maxConcurrent * itemsForEachArray < resultsCount {
            itemsForEachArray += 1
        }
        await withTaskGroup { [weak self] group in
            for batch in 0...(maxConcurrent - 1) {
                group.addTask {
                    for number in 0...(itemsForEachArray - 1) {
                        let index = batch * itemsForEachArray + number
                        guard index < resultsCount else {
                            continue
                        }
                        let item = results[index]
                        let context = savingContext.makeContext()
                        self?.updateSyncingProgress(updateCurrent: true)
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
    
    nonisolated
    private func updateSyncingProgress(name: String? = nil, total: Int? = nil, updateCurrent: Bool = false) {
        Task { @MainActor in
            if let name {
                await syncingActor.setProcess()
            }
            if let total {
                await syncingActor.setTotal(total)
            }
            if updateCurrent {
                await syncingActor.updateCurrent()
            }
            currentProcess = await syncingActor.process
            syncingProgress = await syncingActor.fetchProgress()
        }
    }
}

actor SyncingProgress {
    var process: Int
    var totalItems: Int
    var currentItems: Int
    
    init(process: Int = 0, totalItems: Int = 0, currentItems: Int = 0) {
        self.process = process
        self.totalItems = totalItems
        self.currentItems = currentItems
    }
    
    func setProcess() {
        self.process += 1
    }
    
    func setTotal(_ total: Int) {
        totalItems = total
        currentItems = 0
    }
    
    func updateCurrent() {
        currentItems = currentItems + 1
    }
    
    func fetchProgress() -> Double {
        return Double(currentItems) / Double(totalItems)
    }
}

