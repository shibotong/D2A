//
//  HeroDetailViewV2.swift
//  D2A
//
//  Created by Shibo Tong on 27/7/2025.
//

import SwiftUI

struct HeroDetailViewV2: View {
    
    let hero: Hero
    
    private let detailSpacing: CGFloat = 2
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                titleView
                detailView
            }
        }
        Text(hero.abilities?.description ?? "No abilities")
    }
    
    private var titleView: some View {
        HStack {
            HeroImageViewV2(name: hero.name ?? "", type: .full)
                .frame(height: 50)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            Text(hero.heroNameLocalized)
                .font(.largeTitle)
                .bold()
            Spacer()
        }
        .padding()
        .background(Color.tertiarySystemBackground)
    }
    
    private var detailView: some View {
        HStack(spacing: 10) {
            attackType
            roleView
            Spacer()
        }
        .font(.caption)
        .padding()
        .background(Color.secondarySystemBackground)
    }
    
    @ViewBuilder
    private var roleView: some View {
        if let roles = hero.rolesCollection {
            HStack(spacing: detailSpacing) {
                Image("ic_tag")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 15, height: 15)
                    .foregroundStyle(Color.label)
                Text(roles.joined(separator: ", "))
            }
        }
    }
    
    private var attackType: some View {
        HStack(spacing: detailSpacing) {
            Image(hero.attackType == "Melee" ? "ic_sword" : "ic_archer")
                .renderingMode(.template)
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundStyle(Color.label)
            Text(hero.attackType ?? "Unknown")
        }
    }
}

#if DEBUG
#Preview {
    HeroDetailViewV2(hero: Hero.antimage)
        .environmentObject(ImageController.preview)
}
#endif
