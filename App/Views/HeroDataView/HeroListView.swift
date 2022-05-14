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
        List {
            ForEach(herodata.fetchAllHeroes()) { hero in
                buildHero(hero: hero)
            }
        }
    }
    
    @ViewBuilder private func buildHero(hero: Hero) -> some View {
        HStack {
            HeroImageView(heroID: hero.id, type: .full).frame(width: 50)
            Text(hero.localizedName)
        }
    }
}

struct HeroListView_Previews: PreviewProvider {
    static var previews: some View {
        HeroListView()
            .environmentObject(HeroDatabase.shared)
    }
}
