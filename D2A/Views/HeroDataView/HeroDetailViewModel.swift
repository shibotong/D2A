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
    @Published var hero: Hero?
    @Published var selectedAbility: String?
    
    @Published var heroID: Int
    
    @Published var previousHeroID: Int?
    @Published var nextHeroID: Int?
    
    private var database: HeroDatabase = HeroDatabase.shared
    
    init(heroID: Int) {
        self.heroID = heroID
        $heroID
            .map { [weak self] heroID in
                let cachedHero = Hero.fetchHero(id: Double(heroID))
                self?.loadHero(hero: cachedHero, id: heroID)
                return cachedHero
            }
            .assign(to: &$hero)
        
        $heroID
            .map { [weak self] id in
                let heroid = self?.getNextHeroID(id: id)
                return heroid
            }
            .assign(to: &$nextHeroID)
        
        $heroID
            .map { [weak self] id in
                return self?.getPreviousHeroID(id: id)
            }
            .assign(to: &$previousHeroID)
        
        $hero
            .map { hero in
                return hero?.abilities?.first
            }
            .assign(to: &$selectedAbility)
    }
    
    func fetchAbility(name: String) -> Ability? {
        return database.fetchOpenDotaAbility(name: name)
    }
    
    /// Load hero
    func loadHero(hero: Hero?, id: Int) {
        if let lastFetch = hero?.lastFetch, lastFetch.startOfDay == Date().startOfDay {
            // if hero exist and already fetched today, dont download hero
            return
        }
        downloadHero(heroID: id)
    }
    
    /// Download hero from API
    func downloadHero(heroID: Int) {
        Network.shared.apollo.fetch(query: HeroQuery(id: Double(heroID))) { [weak self] (result: Result<GraphQLResult<HeroQuery.Data>, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let graphQLResult):
                if let hero = graphQLResult.data?.constants?.hero {
                    do {
                        let model = try self.database.fetchHeroWithID(id: self.heroID)
                        let abilities = self.database
                            .fetchHeroAbility(name: model.name)
                            .filter { ability in
                            return !ability.contains("hidden") && !ability.contains("empty")
                        }
                        let newHero = try Hero.createHero(hero, model: model, abilities: abilities)
                        DispatchQueue.main.async { [weak self] in
                            self?.hero = newHero
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }
                
                if let errors = graphQLResult.errors {
                    let message = errors
                        .map { $0.localizedDescription }
                        .joined(separator: "\n")
                    print(message)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func fetchTalentName(id: Short) -> String {
        return database.getTalentDisplayName(id: id)
    }
    
    func getNextHeroID(id: Int) -> Int {
        let heroList = HeroDatabase.shared.fetchAllHeroes().sorted { $0.heroNameLocalized < $1.heroNameLocalized }
        let heroIndex = heroList.firstIndex { $0.id == id } ?? 0
        var nextIndex = heroIndex + 1
        if nextIndex == heroList.endIndex {
            nextIndex = 0
        }
        let nextHero = heroList[nextIndex]
        let nextHeroID = nextHero.id
        return nextHeroID
    }
    
    func getPreviousHeroID(id: Int) -> Int {
        let heroList = HeroDatabase.shared.fetchAllHeroes().sorted { $0.heroNameLocalized < $1.heroNameLocalized }
        let heroIndex = heroList.firstIndex { $0.id == id } ?? 0
        var previousIndex = heroIndex - 1
        if heroIndex == heroList.startIndex {
            previousIndex = heroList.endIndex - 1
        }
        let previousHero = heroList[previousIndex]
        let previousHeroID = previousHero.id
        return previousHeroID
    }
}
