//
//  HeroDetailViewModel.swift
//  App
//
//  Created by Shibo Tong on 15/5/2022.
//

import Foundation
import UIKit

class HeroDetailViewModel: ObservableObject {
    @Published var hero: Hero
    @Published var heroAbility: HeroAbility
    @Published var selectedAbility: AbilityContainer?
    @Published var talents = [HeroQuery.Data.Constant.Hero.Talent]()
    
    static var preview = HeroDetailViewModel()
    
    var heroID: Int
    private var database: HeroDatabase = HeroDatabase.shared
    
    init(heroID: Int) {
        self.heroID = heroID
        let hero = database.fetchHeroWithID(id: heroID)!
        self.hero = hero
        self.heroAbility = database.fetchHeroAbility(name: hero.name)!
        self.fetchAbilities(id: heroID)
    }
    
    init() {
        self.heroID = 1
        self.hero = Hero.sample
        self.heroAbility = HeroAbility.sample
    }
    
    func fetchAbility(name: String) -> Ability {
        return database.fetchAbility(name: name)!
    }
    
    private func fetchAbilities(id: Int) {
        Network.shared.apollo.fetch(query: HeroQuery(id: Double(id))) { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success(let graphQLResult):
                if let hero = graphQLResult.data?.constants?.hero, let talents = hero.talents?.compactMap({ $0 }) {
                    self.talents = talents
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
