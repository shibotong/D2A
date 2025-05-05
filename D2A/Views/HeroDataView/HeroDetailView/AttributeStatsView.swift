//
//  AttributeStatsView.swift
//  D2A
//
//  Created by Shibo Tong on 5/5/2025.
//

import SwiftUI

struct AttributeStatsView: View {
    
    let level: Int
    let hero: Hero
    
    var body: some View {
        HStack {
            Spacer()
            buildStatLevel(type: .str)
            Spacer()
            buildStatLevel(type: .agi)
            Spacer()
            buildStatLevel(type: .int)
            Spacer()
        }
    }
    
    @ViewBuilder
    private func buildStatLevel(type: HeroAttribute) -> some View {
        HStack {
            let gain = hero.getGain(type: type)
            AttributeImage(attribute: type)
                .frame(width: 15, height: 15)
            Text("\(hero.calculateAttribute(level: Double(level), attr: type))")
                .font(.system(size: 18))
                .bold()
            Text("+ \(gain, specifier: "%.1f")")
                .font(.system(size: 13))
        }
    }
}

#Preview {
    AttributeStatsView(level: 1, hero: PersistanceController.previewHeroes.first!)
}


