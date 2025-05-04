//
//  PersistanceController+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 4/5/2025.
//

import CoreData

extension PersistanceController {
    
    static let previewContext: NSManagedObjectContext = {
        let controller = PersistanceController(inMemory: true)
        let heroes = loadSampleHero() ?? [:]
        
        let context = controller.container.viewContext
        
        for (heroID, heroModel) in heroes {
            let hero = Hero(context: context)
            hero.saveHeroToCoreData(context: context, openDotaHero: heroModel)
            try? context.save()
        }
        return context
    }()
    
    static let previewHeroes: [Hero] = {
        let heroes = try? PersistanceController.previewContext.fetch(Hero.fetchRequest())
        return heroes ?? []
    }()
}
