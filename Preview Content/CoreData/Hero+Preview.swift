//
//  Hero+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 7/5/2025.
//

extension Hero {
    static let previewHeroes: [Hero] = {
        let provider = PersistanceProvider.previewProvider
        let heroes = OpenDotaConstantProvider.previewHeroes
        provider.saveODData(data: heroes, type: Hero.self, mainContext: true)
        return (try? provider.mainContext.fetch(Hero.fetchRequest())) ?? []
    }()
    
    static let antimage: Hero = {
        let context = PersistanceProvider.previewProvider.mainContext
        let hero = OpenDotaConstantProvider.previewHero(id: 1)!
        return try! hero.update(context: context) as! Hero
    }()
    
    static func loadHero(id: Int) -> Hero {
        let context = PersistanceProvider.preview.container.viewContext
        return Hero.fetch(id: id, context: context)!
    }
}
