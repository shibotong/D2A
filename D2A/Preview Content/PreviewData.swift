//
//  PreviewData.swift
//  D2A
//
//  Created by Shibo Tong on 6/4/2026.
//

import CoreData

class PreviewData {
    static let environment: DotaEnvironment = DotaEnvironment(imageProvider: MockImageProvider())
    
    static var context: NSManagedObjectContext = {
        let context = PersistenceProvider.shared.mainContext
        addPreviewData(context: context)
        return context
    }()
    
    static var heroes: [Hero] {
        let context = Self.context
        let fetchRequest = Hero.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "heroID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        return try! context.fetch(fetchRequest)
    }
    
    static func addPreviewData(context: NSManagedObjectContext) {
        let persistenceService = DataPersistenceService.shared
        
        let abilityIDs = PreviewConstantData.abilityIDs
        let abilityJSON = PreviewConstantData.abilities
        let abilities = persistenceService.sortAbilities(abilityIDs: abilityIDs, abilities: abilityJSON)
        
        for ability in abilities {
            try! persistenceService.save(abilityID: ability.abilityID, name: ability.name, data: ability.data, in: context)
        }
        
        let heroJSON = PreviewConstantData.heroes
        let heroAbilitiesJSON = PreviewConstantData.heroAbilities
        let heroAdditionalData = PreviewConstantData.heroAdditionalData
        
        let heroes = persistenceService.sortHeroes(heroJSON: heroJSON, abilitiesJSON: heroAbilitiesJSON, heroAdditionalDatas: heroAdditionalData)
        
        for hero in heroes {
            try! persistenceService.save(hero: hero, in: context, logger: nil)
        }
        
        let abilityTranslations = PreviewConstantData.abilityTranslation
        for translation in abilityTranslations {
            try! persistenceService.save(ability: translation, language: .english, in: context)
        }
        
        let heroTranslations = PreviewConstantData.heroTranslation
        for translation in heroTranslations {
            try! persistenceService.save(hero: translation, language: .english, in: context)
        }
    }
}
