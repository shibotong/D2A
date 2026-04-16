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
    @Published var hero: (any HeroProtocol)?
    @Published var selectedAbility: AbilityData?
    
    @Published var heroID: Int
    
    @Published var previousHeroID: Int?
    @Published var nextHeroID: Int?
    
    @Published var abilities: [AbilityData] = []
    @Published var talent1Left: String = ""
    @Published var talent2Left: String = ""
    @Published var talent3Left: String = ""
    @Published var talent4Left: String = ""
    @Published var talent1Right: String = ""
    @Published var talent2Right: String = ""
    @Published var talent3Right: String = ""
    @Published var talent4Right: String = ""
    
    private var database: HeroDatabase = HeroDatabase.shared
    private let persistence: PersistenceProviding
    private let context: NSManagedObjectContext
    private let language: DataLanguageEnum
    
    init(hero: any HeroProtocol,
         language: DataLanguageEnum = AppConfig.languageCode,
         persistence: PersistenceProviding = PersistenceProvider.shared) {
        self.hero = hero
        heroID = hero.heroID
        self.persistence = persistence
        self.context = persistence.mainContext
        self.language = language
    }
    
    init(heroID: Int,
         language: DataLanguageEnum = AppConfig.languageCode,
         persistence: PersistenceProviding = PersistenceProvider.shared) {
        self.heroID = heroID
        self.persistence = persistence
        self.context = persistence.mainContext
        self.language = language
        $heroID
            .map { heroID in
                let cachedHero = try? persistence.fetch(heroID: heroID, context: self.context)
                return cachedHero
            }
            .assign(to: &$hero)
        
        $heroID
            .map { [weak self] id in
                return self?.getRelateHeroID(id: id, isPrevious: false)
            }
            .assign(to: &$nextHeroID)
        
        $heroID
            .map { [weak self] id in
                return self?.getRelateHeroID(id: id, isPrevious: true)
            }
            .assign(to: &$previousHeroID)
    }
    
    func fetchTalentName(id: Short) -> String {
        if let localisation = try? persistence.fetch(abilityID: Int(id), language: AppConfig.languageCode, context: PersistenceProvider.shared.mainContext),
           let dname = localisation.displayName {
            return dname
        } else {
            return database.getTalentDisplayName(id: id)
        }
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
    
    func fetchHeroAbilities() {
        guard let hero else {
            return
        }
        abilities = hero.hero.abilities?.compactMap { fetchAbility(name: $0) } ?? []
        talent1Left = fetchAbility(name: hero.hero.talent1left)?.displayName ?? ""
        talent2Left = fetchAbility(name: hero.hero.talent2left)?.displayName ?? ""
        talent3Left = fetchAbility(name: hero.hero.talent3left)?.displayName ?? ""
        talent4Left = fetchAbility(name: hero.hero.talent4left)?.displayName ?? ""
        talent1Right = fetchAbility(name: hero.hero.talent1right)?.displayName ?? ""
        talent2Right = fetchAbility(name: hero.hero.talent2right)?.displayName ?? ""
        talent3Right = fetchAbility(name: hero.hero.talent3right)?.displayName ?? ""
        talent4Right = fetchAbility(name: hero.hero.talent4right)?.displayName ?? ""
    }
    
    private func fetchAbility(name: String?) -> AbilityData? {
        guard let name else {
            return nil
        }
        guard let ability = try? persistence.fetch(ability: name, context: context) else {
            return nil
        }
        let localization = try? persistence.fetch(ability: name, language: language, context: context)
        return AbilityData(ability: ability, localization: localization)
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
