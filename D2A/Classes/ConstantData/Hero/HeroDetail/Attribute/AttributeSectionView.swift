//
//  AttributeSectionView.swift
//  D2A
//
//  Created by Shibo Tong on 7/5/2025.
//

import SwiftUI

struct AttributesSectionView: View {
    
    let hero: Hero
    let level: Int
    
    var body: some View {
        VStack(spacing: 0) {
            SectionTitle(title: "Attribute")
            HealthManaView(level: level, hero: hero)
            AttributeStatsView(level: level, hero: hero)
        }
        .padding(.horizontal)
    }
}

#Preview {
    AttributesSectionView(hero: Hero.previewHeroes.first!, level: 1)
}
