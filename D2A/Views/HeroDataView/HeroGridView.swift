//
//  HeroGridView.swift
//  D2A
//
//  Created by Shibo Tong on 30/11/2025.
//

import SwiftUI

struct HeroGridView: View {
    
    let heroes: [Hero]
    
    private let columns = [GridItem(.adaptive(minimum: 130, maximum: 200), spacing: 8, alignment: .leading)]
    
    var body: some View {
        VStack {
            Text("Hero Grid View \(heroes.count)")
            LazyVGrid(columns: columns) {
                ForEach(heroes) { hero in
                    HeroGridRowView(hero: hero)
                }
            }
        }
    }
}

struct HeroGridRowView: View {
    
    let hero: Hero
    
    var body: some View {
        HeroImageView(heroID: Int(hero.id), type: .full)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .accessibilityIdentifier(hero.heroNameLocalized)
    }
}

#Preview {
    ScrollView {
        HeroGridView(heroes: SampleData.heroes)
    }
}
