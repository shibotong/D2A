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
                .frame(width: 40, height: 40)
            VStack(alignment: .leading) {
                Text(hero.heroNameLocalized).bold()
                Text(LocalizableStrings.hero)
                    .foregroundColor(.secondaryLabel)
                    .font(.caption)
            }
        }
    }
}

#Preview {
    SearchHeroRowView(hero: Hero.antimage)
        .environmentObject(EnvironmentController.preview)
}
