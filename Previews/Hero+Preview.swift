//
//  Hero+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 7/5/2025.
//

extension Hero {
    static let previewHeroes: [Hero] = {
        let heroes = try? PersistanceProvider.previewContext.fetch(Hero.fetchRequest())
        return heroes ?? []
    }()
}
