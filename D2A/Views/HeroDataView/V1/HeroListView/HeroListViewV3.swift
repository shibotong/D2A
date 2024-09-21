//
//  HeroListViewV2.swift
//  D2A
//
//  Created by Shibo Tong on 20/9/2024.
//

import SwiftUI

struct HeroListViewV3: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSize
    
    @FetchRequest(sortDescriptors: [
        NSSortDescriptor(
            keyPath: \Hero.heroNameLocalized,
            ascending: true
            )
    ]) var heroes: FetchedResults<Hero>
    
    private let gridItems = Array(repeating: GridItem(.adaptive(minimum: 130, maximum: 200), spacing: 10, alignment: .leading), count: 1)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            LazyVGrid(columns: gridItems) {
                ForEach(heroes) { hero in
                    NavigationLink(destination: HeroDetailView(vm: HeroDetailViewModel(heroID: Int(hero.id)))) {
                        buildHero(hero: hero)
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func buildHero(hero: Hero) -> some View {
        HeroListCellView(heroName: hero.heroNameLocalized,
                         heroID: Int(hero.id),
                         attribute: HeroAttribute(rawValue: hero.primaryAttr ?? "") ?? .agi,
                         isGrid: true,
                         isHighlighted: true)
    }
}

#Preview {
    HeroListViewV2()
}
