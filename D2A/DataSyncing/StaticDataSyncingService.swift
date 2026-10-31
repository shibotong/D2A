//
//  StaticDataSyncingService.swift
//  D2A
//
//  Created by Shibo Tong on 27/1/2026.
//

import Foundation
import CoreData
import OpenDota
import Stratz

class StaticDataSyncingService: ObservableObject {

    static let shared = StaticDataSyncingService()
    @Published var isCompleted = false
    @Published var currentProcess = 0
    @Published var syncingProgress: Double = 0.0
    
    let totalProcesses = 4
    
    private let contextProvider: CoreDataContextProviding
    private let openDota: OpenDotaFetching
    private let stratz: StratzFetching
    private let language: DataLanguageEnum
    
    private let logger: D2ALogger
    
    private let maxConcurrent: Int
    
    private let persistence: DataPersistenceService
    private let notification: D2ANotification
    
    private let syncingTimer: SyncingTimerProtocol
    
    private var syncingActor: SyncingProgress = SyncingProgress()
    
    init(openDota: OpenDotaFetching = OpenDotaFetcher.shared,
         stratz: StratzFetching = StratzFetcher.shared,
         contextProvider: CoreDataContextProviding = PersistenceProvider.shared,
         persistenceService: DataPersistenceService = .shared,
         appConfig: AppConfigProtocol = AppConfig.shared,
         logger: D2ALogger = .shared,
         notification: D2ANotification = .default,
         syncingTimer: SyncingTimerProtocol = SyncingTimer.shared) {
        self.openDota = openDota
        self.stratz = stratz
        self.contextProvider = contextProvider
        self.persistence = persistenceService
        self.language = appConfig.languageCode
        self.maxConcurrent = max(1, appConfig.processors)
        self.logger = logger
        self.notification = notification
        self.syncingTimer = syncingTimer
    }
    
    func startSyncing() async throws {
        defer {
            isCompleted = true
        }
        isCompleted = false
        let privateContext = contextProvider.backgroundContext(name: "Constant Data")
        let shouldSyncConstants = syncingTimer.shouldSync(key: .constants)
        let shouldSyncLocalization = syncingTimer.shouldSync(key: .localization(language))
        let hasLocalization = try await hasLocalization(for: language, in: privateContext)
        logger.info("Should sync constants: \(shouldSyncConstants)", category: .sync)
        if shouldSyncConstants {
            try await syncAbilities(in: privateContext)
            try await syncHeroes(in: privateContext)
        }
        if shouldSyncLocalization || !hasLocalization {
            try await syncAbilityTranslation(in: privateContext)
        }
        try await privateContext.perform {
            try privateContext.save()
        }
        let mainContext = contextProvider.mainContext
        try await mainContext.perform {
            try mainContext.save()
        }
        notification.syncingCompletion.send(true)
        if shouldSyncConstants {
            syncingTimer.finishSyncing(key: .constants)
        }
        if shouldSyncLocalization || !hasLocalization {
            syncingTimer.finishSyncing(key: .localization(language))
        }
    }
    
    private func hasLocalization(for localization: DataLanguageEnum, in context: NSManagedObjectContext) async throws -> Bool {
        try await context.perform {
            let request = AbilityTranslation.fetchRequest()
            request.predicate = NSPredicate(format: "language = %@", localization.rawValue)
            return try context.count(for: request) > 0
        }
    }
    
    private func syncAbilities(in context: NSManagedObjectContext) async throws {
        logger.trace("Start syncing abilities", category: .sync)
        let persistence = self.persistence
        try await contextSaving(in: context, author: "Ability") {
            async let abilityIDAsync = openDota.abilityIDs()
            async let abilitiesAsync = openDota.abilities()
            let (abilityIDs, abilities) = try await (abilityIDAsync, abilitiesAsync)
            return persistence.sortAbilities(abilityIDs: abilityIDs, abilities: abilities)
        } saving: { ability, context in
            self.logger.trace("Saving ability \(ability.abilityID)", category: .sync)
            try persistence.save(abilityID: ability.abilityID, name: ability.name, data: ability.data, in: context)
        }
    }
    
    private func syncAbilityTranslation(in context: NSManagedObjectContext) async throws {
        let language = self.language
        let persistence = self.persistence
        try await contextSaving(in: context, author: "Ability localization", fetchData: {
            try await stratz.abilities(language: language.language)
        }) { ability, context in
            self.logger.trace("Saving ability localization \(ability.id)", category: .sync)
            try persistence.save(ability: ability, language: language, in: context)
        }
    }
    
    private func syncHeroes(in context: NSManagedObjectContext) async throws {
        logger.trace("Start syncing heroes", category: .sync)
        let persistenceProvider = persistence
        try await contextSaving(in: context, author: "Hero") {
            async let heroesAsync = openDota.heroes()
            async let abilitiesAsync = openDota.heroAbilities()
            async let heroAdditionalDatasAsync = stratz.heroAdditionalData()
            let (heroJSON, abilitiesJSON, heroAdditionalDatas) = try await (heroesAsync, abilitiesAsync, heroAdditionalDatasAsync)
            return persistence.sortHeroes(heroJSON: heroJSON, abilitiesJSON: abilitiesJSON, heroAdditionalDatas: heroAdditionalDatas)
        } saving: { (hero: HeroRecipe, context) in
            self.logger.trace("Saving hero \(hero.heroID)", category: .sync)
            try persistenceProvider.save(hero: hero, in: context)
        }
    }
    
    private func contextSaving<T: Sendable>(
        in parentContext: NSManagedObjectContext,
        author: String,
        fetchData: () async throws -> [T],
        saving: @escaping @Sendable (T, NSManagedObjectContext) throws -> Void
    ) async throws {
        let results = try await fetchData()
        updateSyncingProgress(name: author, total: results.count)
        guard !results.isEmpty else { return }

        let workerCount = min(maxConcurrent, results.count)
        let batchSize = (results.count - 1) / workerCount + 1
        let savingContext = parentContext.makeContext(author: author)
        do {
            try await withThrowingTaskGroup(of: Int.self) { group in
                for start in stride(from: 0, to: results.count, by: batchSize) {
                    let batch = Array(results[start..<min(start + batchSize, results.count)])
                    // Each worker owns one context and saves its entire batch once.
                    let workerContext = savingContext.makeContext(author: author)
                    group.addTask {
                        try Task.checkCancellation()
                        try await workerContext.perform {
                            for item in batch {
                                try saving(item, workerContext)
                            }
                            try workerContext.save()
                        }
                        return batch.count
                    }
                }
                for try await savedCount in group {
                    updateSyncingProgress(completedItems: savedCount)
                }
            }
            try Task.checkCancellation()
            try await savingContext.perform {
                try savingContext.save()
            }
        } catch {
            // All workers have finished before discarding a failed phase.
            await savingContext.perform {
                savingContext.rollback()
            }
            throw error
        }
    }
    
    nonisolated
    private func updateSyncingProgress(name: String? = nil, total: Int? = nil, completedItems: Int = 0) {
        Task { @MainActor in
            if name != nil {
                await syncingActor.setProcess()
            }
            if let total {
                await syncingActor.setTotal(total)
            }
            if completedItems > 0 {
                await syncingActor.updateCurrent(by: completedItems)
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
    
    func updateCurrent(by count: Int) {
        currentItems += count
    }
    
    func fetchProgress() -> Double {
        return totalItems > 0 ? Double(currentItems) / Double(totalItems) : 1
    }
}

