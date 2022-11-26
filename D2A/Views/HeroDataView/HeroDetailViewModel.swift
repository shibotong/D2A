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
    @Published var hero: Hero?
    @Published var selectedAbility: String?
    
    let heroID: Int
    private var database: HeroDatabase = HeroDatabase.shared
    
    init(heroID: Int) {
        self.hero = Hero.fetchHero(id: Double(heroID))
        self.heroID = heroID
    }
    
    func fetchAbility(name: String) -> Ability {
        return database.fetchOpenDotaAbility(name: name)!
    }
    
    /// Load hero
    func loadHero() {
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
                        let model = try self.database.fetchHeroWithID(id: self.heroID)
                        let abilities = self.database
                            .fetchHeroAbility(name: model.name)
                            .filter { ability in
                            return !ability.contains("hidden") && !ability.contains("empty")
                        }
                        let newHero = try Hero.createHero(hero, model: model, abilities: abilities)
                        DispatchQueue.main.async {
                            self.hero = newHero
                        }
                    } catch(let error) {
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
                print(error)
            }
        }
    }
    
    func fetchTalentName(id: Short) -> String {
        return database.getTalentDisplayName(id: id)
    }
}