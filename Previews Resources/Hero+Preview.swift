//
//  Hero+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 27/4/2025.
//

extension Hero {
    static let preview: Hero = {
        let viewContext = PersistanceController.preview.container.viewContext
        let hero = Hero(context: viewContext)
        let heroData = MockOpenDotaConstantProvider().loadSampleHeroes()["1"]!
        hero.update(data: heroData)
        return hero
    }()
}
