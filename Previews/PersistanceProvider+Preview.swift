//
//  PersistanceProvider+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 7/5/2025.
//

import CoreData

#if DEBUG
extension PersistanceProvider {
    static let preview: PersistanceProvider = {
        let provider = PersistanceProvider(inMemory: true)
        let dataProvider = PreviewDataProvider()
        let heroes = dataProvider.loadOpenDotaConstants(service: .heroes, as: [String: ODHero].self)
        
    }()
    static let previewContext: NSManagedObjectContext = {
        let controller = PersistanceProvider(inMemory: true)
        let heroes = loadSampleHero() ?? [:]

        let context = controller.container.viewContext

        for (heroID, heroModel) in heroes {
            let hero = Hero(context: context)
            hero.saveODData(context: context, openDotaHero: heroModel)
            try? context.save()
        }
        return context
    }()
}
#endif
