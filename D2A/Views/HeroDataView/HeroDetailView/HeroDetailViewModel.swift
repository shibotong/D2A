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
    @Published var hp: Int
    @Published var hpRegen: Double
    @Published var mana: Int
    @Published var manaRegen: Double
    @Published var strength: Int
    @Published var agility: Int
    @Published var intelligence: Int
    
    @Published var attackMin: Int
    @Published var attackMax: Int
    @Published var armor: Double
    
    init(hero: Hero, abilities: [Ability]) {
        self.hero = hero
        self.abilities = abilities
        
        hp = hero.calculateHPLevel(level: 1)
        hpRegen = hero.calculateHPRegen(level: 1)
        mana = hero.calculateManaLevel(level: 1)
        manaRegen = hero.calculateMPRegen(level: 1)
        strength = hero.calculateAttribute(level: 1, attr: .str)
        agility = hero.calculateAttribute(level: 1, attr: .agi)
        intelligence = hero.calculateAttribute(level: 1, attr: .int)
        attackMin = hero.calculateAttackByLevel(level: 1, isMin: true)
        attackMax = hero.calculateAttackByLevel(level: 1, isMin: false)
        armor = hero.calculateArmorByLevel(level: 1)
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
    
    private func setupBinding() {
        
    }
}
