//
//  PreviewData.swift
//  D2A
//
//  Created by Shibo Tong on 6/4/2026.
//

import CoreData

class PreviewData {
    static let environment: DotaEnvironment = DotaEnvironment(imageProvider: MockImageProvider())
    
    static let persistenceProvider: PersistenceProvider = {
        let provider = PersistenceProvider(inMemory: true)
        try? addPreviewData(context: provider.mainContext)
        return provider
    }()
    
    static let syncingService: StaticDataSyncingService = StaticDataSyncingService(mainContext: persistenceProvider.mainContext, syncingTimer: PreviewSyncingTimer())
    
    static var heroes: [Hero] {
        let context = Self.persistenceProvider.mainContext
        let fetchRequest = Hero.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "heroID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return (try? context.fetch(fetchRequest)) ?? []
    }
    
    static func addPreviewData(context: NSManagedObjectContext) throws {
        let persistenceService = DataPersistenceService.shared
        let abilityIDs = PreviewConstantData.abilityIDs
        let abilityJSON = PreviewConstantData.abilities
        let abilities = persistenceService.sortAbilities(abilityIDs: abilityIDs, abilities: abilityJSON)
        for ability in abilities {
            try persistenceService.save(abilityID: ability.abilityID, name: ability.name, data: ability.data, in: context)
        }
        
        let heroJSON = PreviewConstantData.heroes
        let heroAbilitiesJSON = PreviewConstantData.heroAbilities
        let heroAdditionalData = PreviewConstantData.heroAdditionalData
        
        let heroes = persistenceService.sortHeroes(heroJSON: heroJSON, abilitiesJSON: heroAbilitiesJSON, heroAdditionalDatas: heroAdditionalData)
        
        for hero in heroes {
            try persistenceService.save(hero: hero, in: context, logger: nil)
        }
        
        let abilityTranslations = PreviewConstantData.abilityTranslation
        for translation in abilityTranslations {
            try persistenceService.save(ability: translation, language: .english, in: context)
        }
        
        let heroTranslations = PreviewConstantData.heroTranslation
        for translation in heroTranslations {
            try persistenceService.save(hero: translation, language: .english, in: context)
        }
        try context.save()
    }
    
    class PreviewAbility {
        static let blink: Ability = fetch(name: "antimage_blink")
        
        static let counterspell: Ability = fetch(name: "antimage_counterspell")
        
        static let manaBreak = fetch(name: "antimage_mana_break")
        
        static let manaVoid = fetch(name: "antimage_mana_void")
        
        static private func fetch(name: String) -> Ability {
            let context = PreviewData.persistenceProvider.mainContext
            let dataService = DataPersistenceService.shared
            return try! dataService.fetch(ability: name, context: context)!
        }
    }
    
    class PreviewHero {
        static let antimage = {
            let context = PreviewData.persistenceProvider.mainContext
            let dataService = DataPersistenceService.shared
            return try! dataService.fetch(heroID: 1, context: context)!
        }()
    }
}
