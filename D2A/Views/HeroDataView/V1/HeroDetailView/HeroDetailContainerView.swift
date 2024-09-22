//
//  HeroDetailContainerView.swift
//  D2A
//
//  Created by Shibo Tong on 22/9/2024.
//

import SwiftUI
import CoreData

struct HeroDetailContainerView: View {
    
    let hero: Hero?
    
    init(hero: Hero) {
        self.hero = hero
    }
    
    init(heroID: Int, viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        let hero = Hero.fetchHero(id: Double(heroID), viewContext: viewContext)
        self.hero = hero
    }
    
    var body: some View {
        if let hero {
            HeroDetailView(hero: hero)
        } else {
            Text("Cannot find hero")
                .font(.caption)
        }
    }
}
