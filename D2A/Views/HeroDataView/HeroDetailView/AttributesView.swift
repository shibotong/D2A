//
//  AttributesView.swift
//  D2A
//
//  Created by Shibo Tong on 5/5/2025.
//

import SwiftUI

struct AttributesView: View {
    
    let hero: Hero
    let level: Int
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Attributes")
                    .font(.system(size: 15))
                    .bold()
                Spacer()
            }.padding(.bottom)
            HealthManaView(level: level, hero: hero)
            AttributeStatsView(level: level, hero: hero)
        }
        .padding(.horizontal)
    }
}

#Preview {
    AttributesView(hero: PersistanceController.previewHeroes.first!, level: 1)
}
