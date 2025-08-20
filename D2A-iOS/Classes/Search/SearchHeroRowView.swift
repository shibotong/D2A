//
//  SearchHeroRowView.swift
//  D2A
//
//  Created by Shibo Tong on 20/8/2025.
//

import SwiftUI

struct SearchHeroRowView: View {
    
    let hero: Hero
    
    var body: some View {
        HStack {
            HeroImageViewV2(name: hero.heroNameLowerCase, type: .icon)
                .frame(width: 30, height: 30)
            Text(hero.heroNameLocalized)
        }
    }
}

#Preview {
    SearchHeroRowView(hero: Hero.antimage)
        .environmentObject(EnvironmentController.preview)
}
