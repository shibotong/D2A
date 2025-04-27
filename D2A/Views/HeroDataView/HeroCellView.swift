//
//  HeroCellView.swift
//  D2A
//
//  Created by Shibo Tong on 27/4/2025.
//

import SwiftUI

struct HeroCellView: View {
    
    @EnvironmentObject var fileController: FileController
    @Environment(\.horizontalSizeClass) var horizontalSize
    
    let hero: Hero
    let isGrid: Bool
    
    var body: some View {
        Group {
            if horizontalSize == .regular {
                regular
            } else if isGrid {
                grid
            } else {
                list
            }
        }
        .accessibilityIdentifier(hero.heroNameLocalized)
    }
    
    private var regular: some View {
        heroImage(type: .vert)
            .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    private var list: some View {
        HStack {
            heroImage(type: .full)
                .frame(width: 70)
                .clipShape(RoundedRectangle(cornerRadius: 5))
            Text(hero.heroNameLocalized)
            Spacer()
            Image("hero_\(hero.primaryAttr!)")
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
    
    private var grid: some View {
        ZStack {
            heroImage(type: .full)
                .overlay(LinearGradient(colors: [.black.opacity(0), .black.opacity(0), .black], startPoint: .top, endPoint: .bottom))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .accessibilityIdentifier(hero.heroNameLocalized)
            HStack {
                VStack {
                    Spacer()
                    HStack(spacing: 3) {
                        AttributeImage(attribute: AttributeSelection(rawValue: hero.primaryAttr!)).frame(width: 15, height: 15)
                        Text(hero.heroNameLocalized)
                            .font(.caption2)
                            .fontWeight(.black)
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }
            .padding(5)
        }
    }
    
    @ViewBuilder
    private func heroImage(type: HeroImageType) -> some View {
        HeroImageView(hero: hero,
                      type: type,
                      imageProvider: fileController.imageProvider)
    }
}

#Preview {
    VStack {
        HeroCellView(hero: Hero.preview, isGrid: true)
        HeroCellView(hero: Hero.preview, isGrid: false)
    }
    .environmentObject(FileController.preview)
    .environmentObject(HeroDatabase.preview)
}
