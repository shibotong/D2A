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
    
    private let openDota: OpenDotaFetching
    
    /// Private context for saving static data
    private let context: NSManagedObjectContext
    
    private let logger: Logger
    
    init(openDota: OpenDotaFetching = OpenDotaController.shared,
         persistance: PersistanceProviding = PersistanceController.shared,
         logger: Logger = D2ALogger.syncing) {
        self.openDota = openDota
        self.context = persistance.mainContext.makeContext(author: "Static Data")
        self.logger = logger
    }
    
    func startSyncing() async {
        do {
            try await syncAbilities()
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
}
