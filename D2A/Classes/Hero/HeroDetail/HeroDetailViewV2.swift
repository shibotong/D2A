//
//  HeroDetailViewV2.swift
//  D2A
//
//  Created by Shibo Tong on 27/7/2025.
//

import SwiftUI

struct HeroDetailViewV2: View {
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    let hero: Hero
    
    @State private var heroLevel: Double = 1
    @State private var abilities: [Ability] = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                titleView
                detailView
                abilitiesView
            }
            Group {
                levelSlider
                    .padding()
                    .background(Color.secondarySystemBackground)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                    
                statsView
            }
            .padding(.horizontal)
        }
        .task {
            self.abilities = loadAbilities()
        }
        Text(hero.abilities?.description ?? "No abilities")
    }
    
    private var abilitiesView: some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(abilities) { ability in
                    AbilityImage(name: ability.name, urlString: ability.img)
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private var statsView: some View {
        if horizontalSizeClass == .compact {
            VStack {
                statsCollection
            }
        } else {
            HStack(alignment: .top) {
                statsCollection
            }
        }
    }
    
    private var statsCollection: some View {
        Group {
            attackStats
            defenceStats
            mobilityStats
        }
        .padding()
        .background(Color.secondarySystemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    
    private var levelSlider: some View {
        HStack {
            Text("\(Int(heroLevel))")
            Slider(value: $heroLevel, in: 1...30, step: 1)
            Text("30")
        }
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
        HStack {
            attackType
            Spacer()
        }
        .font(.caption)
        .padding()
        .background(Color.secondarySystemBackground)
    }
    
    private var attackType: some View {
        HStack {
            Image(hero.attackType == "Melee" ? "ic_sword" : "ic_archer")
                .renderingMode(.template)
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundStyle(Color.label)
            Text(hero.attackType ?? "Unknown")
        }
    }
    
    private var attackStats: some View {
        VStack(alignment: .leading) {
            buildSectionTitle(icon: "ic_sword", title: "Attack")
            Group {
                HeroDetailRow(title: "Attack Speed", value: "\(hero.attackRate)s")
                HeroDetailRow(title: "Damage", value: "\(hero.calculateAttackByLevel(level: heroLevel, isMin: true)) - \(hero.calculateAttackByLevel(level: heroLevel, isMin: false))")
                HeroDetailRow(title: "Attack Range", value: "\(hero.attackRange)")
            }
            .font(.caption)
        }
    }
    
    private var defenceStats: some View {
        VStack(alignment: .leading) {
            buildSectionTitle(icon: "ic_shield", title: "Defense")
            Group {
                HeroDetailRow(title: "Armor", value: "\(String(format: "%.1f", hero.calculateArmorByLevel(level: heroLevel)))")
                HeroDetailRow(title: "Magical Resistance", value: "\(hero.baseMr)%")
            }
            .font(.caption)
        }
    }
    
    private var mobilityStats: some View {
        VStack(alignment: .leading) {
            buildSectionTitle(icon: "ic_shoe", title: "Mobility")
            Group {
                HeroDetailRow(title: "Movement Speed", value: "\(hero.moveSpeed)")
                HeroDetailRow(title: "Turn Rate", value: "\(hero.turnRate)")
                HeroDetailRow(title: "Vision Range", value: "\(Int(hero.visionDaytimeRange))/\(Int(hero.visionNighttimeRange))")
            }
            .font(.caption)
        }
    }
    
    
    @ViewBuilder
    private func buildSectionTitle(icon: String, title: String) -> some View {
        HStack {
            Image(icon)
                .renderingMode(.template)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(Color.label)
            Text(title)
                .bold()
        }
    }
    
    private func loadAbilities() -> [Ability] {
        guard let abilityNames = hero.abilities else {
            return []
        }
        return abilityNames.compactMap { Ability.fetchByName(name: $0, context: context) }
    }
}

#if DEBUG
#Preview {
    NavigationView(content: {
        EmptyView()
        HeroDetailViewV2(hero: Hero.antimage)
    })
    .environmentObject(ImageController.preview)
    .environment(\.managedObjectContext, PersistanceProvider.preview.container.viewContext)
}
#endif
