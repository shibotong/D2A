//
//  OpenDotaConstantProvider+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 16/8/2025.
//

extension OpenDotaConstantProvider {
    static var previewHeroes: [ODHero] {
        let dataProvider = PreviewDataProvider()
        let processor  = OpenDotaConstantProcessor.shared
        let heroDict = dataProvider.loadOpenDotaConstants(service: .heroes, as: [String: ODHero].self) ?? [:]
        let heroAbilities = dataProvider.loadOpenDotaConstants(service: .heroAbilities, as: [String: ODHeroAbilities].self) ?? [:]
        let lores = dataProvider.loadOpenDotaConstants(service: .heroLore, as: [String: String].self) ?? [:]
        let heroes = processor.processHeroes(heroes: heroDict, abilities: heroAbilities, lores: lores).filter({ $0.id <= 10 })
        return heroes
    }
    
    static func previewHero(id: Int) -> ODHero? {
        return previewHeroes.first(where: { $0.id == id })
    }
}
