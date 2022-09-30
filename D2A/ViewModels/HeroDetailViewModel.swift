//
//  HeroDetailViewModel.swift
//  App
//
//  Created by Shibo Tong on 15/5/2022.
//

import Foundation
import UIKit
import CoreData

class HeroDetailViewModel: ObservableObject {
    let heroModel: HeroModel
    @Published var hero: Hero?
    @Published var heroAbility: HeroAbility
    @Published var selectedAbility: AbilityContainer?
    @Published var talents = [HeroQuery.Data.Constant.Hero.Talent]()
    
    static var preview = HeroDetailViewModel()
    
    var heroID: Int
    private var database: HeroDatabase = HeroDatabase.shared
    
    init(heroID: Int) {
        self.heroID = heroID
        let hero = database.fetchHeroWithID(id: heroID)!
        self.heroModel = hero
        self.heroAbility = database.fetchHeroAbility(name: hero.name)!
    }
    
    init() {
        self.heroID = 1
        self.heroModel = HeroModel.sample
        self.heroAbility = HeroAbility.sample
    }
    
    func fetchAbility(name: String) -> Ability {
        return database.fetchAbility(name: name)!
    }
    
    /// Load hero
    func loadHero() {
        hero = Hero.fetchHero(id: Double(heroID))
        if let lastFetch = hero?.lastFetch, lastFetch.startOfDay == Date().startOfDay {
            // if hero exist and already fetched today, dont download hero
            return
        }
        downloadHero()
    }
    
    /// Download hero from API
    func downloadHero() {
        Network.shared.apollo.fetch(query: HeroQuery(id: Double(heroID))) { result in
            switch result {
            case .success(let graphQLResult):
                if let hero = graphQLResult.data?.constants?.hero {
                    do {
                        let newHero = try Hero.createHero(hero, model: self.heroModel)
                        DispatchQueue.main.async {
                            self.hero = newHero
                        }
                    } catch {
                        print("creating hero error")
                    }
                }
                
                if let errors = graphQLResult.errors {
                    let message = errors
                        .map { $0.localizedDescription }
                        .joined(separator: "\n")
                    print(message)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchTalentName(id: Short) -> String {
        return database.getTalentDisplayName(id: id)
    }
}
