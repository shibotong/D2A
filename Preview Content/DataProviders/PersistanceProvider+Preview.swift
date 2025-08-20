//
//  PersistanceProvider+Preview.swift
//  D2A
//
//  Created by Shibo Tong on 7/5/2025.
//

import CoreData

extension PersistanceProvider {
    static var preview: PersistanceProvider = {
        let provider = PersistanceProvider(inMemory: true)
        let dataProvider = PreviewDataProvider()
        let processor  = OpenDotaConstantProcessor.shared
        let heroDict = dataProvider.loadOpenDotaConstants(service: .heroes, as: [String: ODHero].self) ?? [:]
        let heroAbilities = dataProvider.loadOpenDotaConstants(service: .heroAbilities, as: [String: ODHeroAbilities].self) ?? [:]
        let lores = dataProvider.loadOpenDotaConstants(service: .heroLore, as: [String: String].self) ?? [:]
        let heroes = processor.processHeroes(heroes: heroDict, abilities: heroAbilities, lores: lores).filter({ $0.id <= 10 })
        provider.saveODData(data: heroes, type: Hero.self, mainContext: true)
        
        let abilityNames = fetchAbilityIDs(heroes: heroes)
        let abilityDict = dataProvider.loadOpenDotaConstants(service: .abilities, as: [String: ODAbility].self) ?? [:]
        let abilityIDs = dataProvider.loadOpenDotaConstants(service: .abilityIDs, as: [String: String].self) ?? [:]
        let scepters = dataProvider.loadOpenDotaConstants(service: .aghs, as: [ODScepter].self) ?? []
        let abilities = processor.processAbilities(ability: abilityDict, ids: abilityIDs, scepters: scepters).filter { abilityNames.contains($0.name ?? "") }
        provider.saveODData(data: abilities, type: Ability.self, mainContext: true)
        
        let gameModes = processor.processGameModes(modes: dataProvider.loadOpenDotaConstants(service: .gameMode, as: [String: ODGameMode].self) ?? [:])
        provider.saveODData(data: gameModes, type: GameMode.self, mainContext: true)
        
        let context = provider.mainContext
        
        let user = OpenDotaProvider.user
        let savedUser = try! user.update(context: context) as! UserProfile
        
        let searchedHero = try! context.fetchOne(type: Hero.self)!
        let searchHistory = SearchHistory(context: context)
        searchHistory.searchTime = Date()
        searchHistory.hero = searchedHero
        
        let searchHistory2 = SearchHistory(context: context)
        searchHistory2.searchTime = Date()
        searchHistory2.player = savedUser
        try! context.save()
        return provider
    }()
    
    static let previewContext: NSManagedObjectContext = {
        let provider = PersistanceProvider.preview
        return provider.container.viewContext
    }()
    
    static let previewProvider: PersistanceProvider = PersistanceProvider(inMemory: true)
    
    static private func fetchAbilityIDs(heroes: [ODHero]) -> [String] {
        var ids: [String] = []
        for hero in heroes {
            ids.append(contentsOf: hero.abilities)
            ids.append(contentsOf: hero.talents.map { $0.ability })
        }
        return ids
    }
}
