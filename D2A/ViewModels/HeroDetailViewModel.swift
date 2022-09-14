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
    
    static var preview = HeroDetailViewModel()
    
    var heroID: Int
    private var database: HeroDatabase = HeroDatabase.shared
    
    init(heroID: Int) {
        self.heroID = heroID
        let hero = database.fetchHeroWithID(id: heroID)!
        self.hero = hero
        self.heroAbility = database.fetchHeroAbility(name: hero.name)!
    }
    
    init() {
        self.heroID = 1
        self.hero = Hero.sample
        self.heroAbility = HeroAbility.sample
    }
    
    func fetchAbility(name: String) -> Ability {
        return database.fetchAbility(name: name)!
    }
}
