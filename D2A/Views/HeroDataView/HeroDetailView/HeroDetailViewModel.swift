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
    }
    
    convenience init(heroID: Int,
                     language: DataLanguageEnum = AppConfig.shared.languageCode,
                     context: NSManagedObjectContext = PersistenceProvider.shared.mainContext,
                     persistence: DataPersistenceService = .shared) {
        let hero = (try? persistence.fetch(heroID: heroID, context: context)) ?? Hero(context: context)
        self.init(hero: hero, language: language, context: context, persistence: persistence)
    }
    
    func getRelateHeroID(id: Int, isPrevious: Bool) -> Int? {
        let heroList = HeroDatabase.shared.fetchAllHeroes().sorted { $0.heroNameLocalized < $1.heroNameLocalized }
        let heroIndex = heroList.firstIndex { $0.id == id } ?? 0
        var index = 0
        if isPrevious {
            index = heroIndex + 1
            if heroIndex == heroList.endIndex {
                index = heroList.startIndex
            }
        } else {
            index = heroIndex - 1
            if heroIndex == heroList.startIndex {
                index = heroList.endIndex
            }
        }
        guard index >= 0 && index < heroList.count else {
            return nil
        }
        let nextHero = heroList[index]
        let nextHeroID = nextHero.id
        return nextHeroID
    }
    
//    func getNextHeroID(id: Int) -> Int? {
//        let heroList = HeroDatabase.shared.fetchAllHeroes().sorted { $0.heroNameLocalized < $1.heroNameLocalized }
//        let heroIndex = heroList.firstIndex { $0.id == id } ?? 0
//        var nextIndex = heroIndex + 1
//        if nextIndex == heroList.endIndex {
//            nextIndex = 0
//        }
//        guard nextIndex >= 0 && nextIndex < heroList.count else {
//            return nil
//        }
//        let nextHero = heroList[nextIndex]
//        let nextHeroID = nextHero.id
//        return nextHeroID
//    }
//    
//    func getPreviousHeroID(id: Int) -> Int? {
//        let heroList = HeroDatabase.shared.fetchAllHeroes().sorted { $0.heroNameLocalized < $1.heroNameLocalized }
//        let heroIndex = heroList.firstIndex { $0.id == id } ?? 0
//        var previousIndex = heroIndex - 1
//        if heroIndex == heroList.startIndex {
//            previousIndex = heroList.endIndex - 1
//        }
//        guard previousIndex >= 0 && previousIndex < heroList.count else {
//            return nil
//        }
//        let previousHero = heroList[previousIndex]
//        let previousHeroID = previousHero.id
//        return previousHeroID
//    }
}
