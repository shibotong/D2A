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
    @Published var hero: any HeroProtocol
    
    let name: String
    let primaryAttribute: String
    let localizedName: String
    let complexity: Int
    
    @Published var selectedAbility: Ability?
    
    @Published var heroID: Int
    
    @Published var previousHeroID: Int?
    @Published var nextHeroID: Int?
    
    @Published var abilities: [Ability] = []
    @Published var talent1Left: String = ""
    @Published var talent2Left: String = ""
    @Published var talent3Left: String = ""
    @Published var talent4Left: String = ""
    @Published var talent1Right: String = ""
    @Published var talent2Right: String = ""
    @Published var talent3Right: String = ""
    @Published var talent4Right: String = ""
    
    @Published var heroLevel = 1.00
    
    private var database: HeroDatabase = HeroDatabase.shared
    private let persistence: DataPersistenceService
    private let context: NSManagedObjectContext
    private let language: DataLanguageEnum
    
    init(hero: any HeroProtocol,
         language: DataLanguageEnum = AppConfig.shared.languageCode,
         context: NSManagedObjectContext = PersistenceProvider.shared.mainContext,
         persistence: DataPersistenceService = .shared) {
        self.hero = hero
        heroID = hero.heroID
        self.persistence = persistence
        self.context = context
        self.language = language
        abilities = hero.heroAbilities
        self.name = hero.heroName
        self.primaryAttribute = hero.primaryAttribute
        self.localizedName = hero.localizedName
        self.complexity = Int(hero.hero.complexity)
    }
    
    convenience init(heroID: Int,
                     language: DataLanguageEnum = AppConfig.shared.languageCode,
                     context: NSManagedObjectContext = PersistenceProvider.shared.mainContext,
                     persistence: DataPersistenceService = .shared) {
        let hero = (try? persistence.fetch(heroID: heroID, context: context)) ?? Hero(context: context)
        self.init(hero: hero, language: language, context: context, persistence: persistence)
    }
}
