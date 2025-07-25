//
//  HealthManaView.swift
//  D2A
//
//  Created by Shibo Tong on 7/5/2025.
//

import SwiftUI

struct HealthManaView: View {

    let level: Int

    let hero: Hero

    var body: some View {
        VStack {
            ForEach(Hero.HeroHPMana.allCases, id: \.rawValue) { value in
                buildBar(
                    amount: hero.calculateHPManaByLevel(level: Double(level), type: value),
                    gain: hero.calculateHPManaRegenByLevel(level: Double(level), type: value),
                    title: value.rawValue,
                    color: barColor(value))
            }
        }
    }

    private func barColor(_ type: Hero.HeroHPMana) -> Color {
        switch type {
        case .hp:
            return Color(UIColor.systemGreen)
        case .mana:
            return Color(UIColor.systemBlue)
        }
    }

    @ViewBuilder
    private func buildBar(amount: Int, gain: Double, title: String, color: Color) -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(LocalizedStringKey(title))
                    .font(.system(size: 15))
                    .bold()
                    .foregroundColor(.secondaryLabel)
                Spacer()
                Text("\(amount)")
                    .font(.system(size: 15))
                    .bold()
                Text("+ \(gain, specifier: "%.1f")")
                    .font(.system(size: 13))
            }
            GeometryReader { proxy in
                let rectangles = Double(amount) / 250.00
                let numberOfRect = amount / 250
                let spacer = (amount % 250 == 0) ? numberOfRect : numberOfRect + 1
                let restWidth = proxy.size.width - CGFloat(spacer)
                let rectWidth = restWidth / rectangles

                HStack(spacing: 1) {
                    ForEach(0..<numberOfRect, id: \.self) { _ in
                        Rectangle()
                            .frame(width: rectWidth)
                    }
                    Rectangle()
                }
                .frame(height: 10)
                .foregroundColor(color)
                .clipShape(Capsule())
            }
        }
    }
}

#if DEBUG
#Preview {
    HealthManaView(level: 1, hero: Hero.previewHeroes.first!)
}
#endif
