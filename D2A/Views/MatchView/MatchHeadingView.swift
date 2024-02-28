//
//  MatchHeadingView.swift
//  D2A
//
//  Created by Shibo Tong on 18/2/2024.
//

import SwiftUI

struct MatchHeadingView: View {
    
    var radiantHeroes: [Int]
    var direHeroes: [Int]
    
    private let iconWidth: CGFloat = 30
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        ZStack {
            if horizontalSizeClass == .regular {
                HStack(spacing: 20) {
                    buildHeroRow(heroes: radiantHeroes)
                    Text("vs")
                        .bold()
                    buildHeroRow(heroes: direHeroes)
                }
            } else {
                VStack {
                    buildHeroRow(heroes: radiantHeroes)
                    
                    Text("vs")
                        .bold()
                    
                    buildHeroRow(heroes: direHeroes)
                }
            }
        }
        .padding()
        .background(Color.secondarySystemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    @ViewBuilder
    private func buildHeroRow(heroes: [Int]) -> some View {
        HStack(spacing: 20) {
            ForEach(heroes, id: \.self) { heroID in
                HeroImageView(heroID: heroID, type: .icon)
                    .frame(width: iconWidth)
            }
        }
    }
}

#Preview {
    MatchHeadingView(radiantHeroes: [1, 2, 3, 4, 5], direHeroes: [6, 7, 8, 9, 10])
}
