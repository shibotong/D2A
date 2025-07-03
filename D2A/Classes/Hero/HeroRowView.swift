//
//  HeroRowView.swift
//  D2A
//
//  Created by Shibo Tong on 17/6/2025.
//

import SwiftUI

struct HeroRowView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var hero: Hero
    var isGrid: Bool
    
    var body: some View {
        Group {
            if horizontalSizeClass == .regular {
                vertical
            } else if isGrid {
                gridView
            } else {
                list
            }
        }
    }
    
    private var vertical: some View {
        HeroImageView(heroID: Int(hero.id), type: .vert)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var list: some View {
        HStack {
            HeroImageView(heroID: Int(hero.id), type: .full)
                .frame(width: 70)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            Text(hero.heroNameLocalized)
            Spacer()
            if let attribute = hero.primaryAttr {
                Image("hero_\(attribute)")
                    .resizable()
                    .frame(width: 20, height: 20)
            }
        }
    }
    
    private var gridView: some View {
        HeroImageView(heroID: Int(hero.id), type: .full)
            .overlay(
                LinearGradient(
                    colors: [.black.opacity(0), .black.opacity(0), .black],
                    startPoint: .top,
                    endPoint: .bottom)
            )
            .overlay(alignment: .bottomLeading, content: {
                HStack(spacing: 3) {
                    Image(hero.attribute.image)
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text(hero.heroNameLocalized)
                        .font(.caption2)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                }
                .padding(5)
            })
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .accessibilityIdentifier(hero.heroNameLocalized)
    }
}

#Preview("Compact Grid") {
    HeroRowView(hero: Hero.previewHeroes.first!, isGrid: true)
        .environment(\.horizontalSizeClass, .compact)
        .environmentObject(ConstantsController.preview)
        .environmentObject(ImageController.preview)
}

#Preview("Compact List") {
    HeroRowView(hero: Hero.previewHeroes.first!, isGrid: false)
        .environment(\.horizontalSizeClass, .compact)
        .environmentObject(ConstantsController.preview)
        .environmentObject(ImageController.preview)
}

#Preview("Regular") {
    HeroRowView(hero: Hero.previewHeroes.first!, isGrid: true)
        .environment(\.horizontalSizeClass, .regular)
        .environmentObject(ConstantsController.preview)
        .environmentObject(ImageController.preview)
}
