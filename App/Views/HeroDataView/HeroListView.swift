//
//  HeroListView.swift
//  App
//
//  Created by Shibo Tong on 29/10/21.
//

import SwiftUI

struct HeroListView: View {
    @EnvironmentObject var herodata: HeroDatabase
    var body: some View {
        ScrollView {
            LazyVGrid(columns: Array(repeating: GridItem(.adaptive(minimum: 100, maximum: 150), spacing: 10, alignment: .leading), count: 3)){
                ForEach(herodata.fetchAllHeroes()) { hero in
                   
                        buildHero(hero: hero)
                    
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder private func buildHero(hero: Hero) -> some View {
        HeroImageView(heroID: hero.id, type: .full)
    }
}

struct HeroListView_Previews: PreviewProvider {
    static var previews: some View {
        HeroListView()
            .environmentObject(HeroDatabase.shared)
    }
}
