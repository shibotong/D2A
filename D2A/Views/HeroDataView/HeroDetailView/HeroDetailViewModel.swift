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
    @Published var selectedAbility: ODAbility?
    
    @Published var heroID: Int
    
    @Published var previousHeroID: Int?
    @Published var nextHeroID: Int?
    
    @Published var abilities: [ODAbility] = []
    
    private var database: HeroDatabase = HeroDatabase.shared
    private let persistence: PersistenceProviding
    private let context: NSManagedObjectContext
    
    init(hero: any HeroProtocol,
         persistence: PersistenceProviding = PersistenceProvider.shared) {
        self.hero = hero
        heroID = hero.heroID
        self.persistence = persistence
        self.context = persistence.mainContext
    }
    
    init(heroID: Int,
         persistence: PersistenceProviding = PersistenceProvider.shared) {
        self.heroID = heroID
        self.persistence = persistence
        self.context = persistence.mainContext
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
        
        $hero
            .map { [weak self] hero in
                guard let abilityNames = hero?.heroAbilities else {
                    return []
                }
                let abilities = abilityNames.filter { ability in
                    let containHidden = ability.contains("hidden")
                    let containEmpty = ability.contains("empty")
                    return !containHidden && !containEmpty
                }.compactMap { [weak self] abilityName in
                    self?.database.fetchOpenDotaAbility(name: abilityName)
                }
                self?.selectedAbility = abilities.first
                return abilities
            }
            .assign(to: &$abilities)
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
