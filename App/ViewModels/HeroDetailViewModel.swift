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
    
    private var database: HeroDatabase = HeroDatabase.shared
    
    init(heroID: Int) {
        let hero = database.fetchHeroWithID(id: heroID)!
        self.hero = hero
        self.heroAbility = database.fetchHeroAbility(name: hero.name)!
    }
    
    func fetchAbility(name: String) -> Ability {
        return database.fetchAbility(name: name)!
    }
}
