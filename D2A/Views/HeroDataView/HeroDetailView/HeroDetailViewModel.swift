//
//  HeroDetailViewModel.swift
//  App
//
//  Created by Shibo Tong on 15/5/2022.
//

import Foundation
import UIKit
import CoreData
import StratzAPI
import Apollo

class HeroDetailViewModel: ObservableObject {
    
    let hero: Hero
    let abilities: [Ability]
    
    @Published var selectedAbility: Ability?
    @Published var heroLevel = 1.00
    
    init(hero: Hero, abilities: [Ability]) {
        self.hero = hero
        self.abilities = abilities
    }
    
    convenience init(hero: any HeroProtocol) {
        self.init(hero: hero.hero,
                  abilities: hero.heroAbilities)
    }
    
    convenience init(heroID: Int,
                     language: DataLanguageEnum = AppConfig.shared.languageCode,
                     context: NSManagedObjectContext = PersistenceProvider.shared.mainContext,
                     persistence: DataPersistenceService = .shared) {
        let hero = (try? persistence.fetch(heroID: heroID, context: context)) ?? Hero(context: context)
        self.init(hero: hero)
    }
}
