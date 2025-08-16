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

    @State private var heroLevel: Double = 1
    @State private var abilities: [Ability] = []
    @State private var selectedAbility: Ability?
    
    let hero: Hero
    private let detailSpacing: CGFloat = 2
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                titleView
                detailView
                abilitiesView
            }
            VStack {
                Group {
                    levelSlider
                    HealthManaView(level: Int(heroLevel), hero: hero)
                    
                }
                .padding()
                .background(Color.secondarySystemBackground)
                .clipShape(RoundedRectangle(cornerRadius: 5))
                stackBuilder(views: attributeCollection)
                stackBuilder(views: statsCollection)
                stackBuilder(views: talentsLoreCollection)
            }
            .padding(.horizontal)
        }
        .sheet(item: $selectedAbility, content: { ability in
            AbilityViewV2(ability: ability)
        })
        .task {
            self.abilities = loadAbilities()
        }
    }
    
    private var talentsLoreCollection: some View {
        Group {
            talentsView
            loreView
        }
        .padding()
        .background(Color.secondarySystemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    
    private var loreView: some View {
        Text("\(hero.lore)")
            .font(.caption2)
    }
    
    private var talentsView: some View {
        VStack(alignment: .leading) {
            buildSectionTitle(title: "Talents")
            if let talents = hero.talents {
                buildTalents(level: 4, talents: talents)
                buildTalents(level: 3, talents: talents)
                buildTalents(level: 2, talents: talents)
                buildTalents(level: 1, talents: talents)
            }
        }
    }
    
    private var abilitiesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(abilities) { ability in
                    AbilityImage(name: ability.name, isInnate: ability.isInnate)
                        .frame(width: 40, height: 40)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            selectedAbility = ability
                        }
                }
            }
            .padding()
        }
    }
    
    @ViewBuilder
    private func stackBuilder(views: some View) -> some View {
        if horizontalSizeClass == .compact {
            VStack {
                views
            }
        } else {
            HStack(alignment: .top) {
                views
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
    
    private var attributeCollection: some View {
        Group {
            buildAttribute(attribute: .str)
            buildAttribute(attribute: .agi)
            buildAttribute(attribute: .int)
        }
        .padding()
        .background(Color.secondarySystemBackground)
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }
    
    @ViewBuilder
    private func buildAttribute(attribute: HeroAttribute) -> some View {
        let gain = hero.getGain(type: attribute)
        HStack {
            buildSectionTitle(icon: attribute.image, title: attribute.displayName, renderMode: .original)
            Spacer()
            Text("\(hero.calculateAttribute(level: heroLevel, attr: attribute))")
                .bold()
            Text("+ \(gain, specifier: "%.1f")")
        }
    }
    
    private var levelSlider: some View {
        HStack {
            Text("\(Int(heroLevel))")
                .bold()
            Slider(value: $heroLevel, in: 1...30, step: 1)
            Text("30")
        }
    }
    
    private var titleView: some View {
        HStack {
            HeroImageViewV2(name: hero.heroNameLowerCase, type: .full)
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
                Spacer()
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
    private func buildSectionTitle(icon: String? = nil, title: String, renderMode: Image.TemplateRenderingMode = .template) -> some View {
        HStack {
            if let icon {
                Image(icon)
                    .renderingMode(renderMode)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.label)
            }
            Text(title)
                .bold()
        }
    }
    
    @ViewBuilder
    private func buildTalents(level: Int, talents: [Talent]) -> some View {
        let filteredTalents = talents.filter { $0.slot == level }
        let frameSize: CGFloat = 40
        HStack {
            Text("\(5 + 5 * level)")
                .font(.body)
                .bold()
                .padding(5)
                .frame(width: frameSize, height: frameSize)
                .background(Circle().stroke().foregroundColor(.yellow))
            VStack(alignment: .leading) {
                ForEach(filteredTalents, id: \.ability) { talent in
                    if let ability = fetchTalent(for: talent.ability) {
                        Text(ability.displayName ?? "")
                            .font(.caption)
                    }
                }
            }
            Spacer()
        }
    }
    
    private func loadAbilities() -> [Ability] {
        guard let abilityNames = hero.abilities else {
            return []
        }
        var abilities = abilityNames.compactMap { Ability.fetchByName(name: $0, context: context)
        }
        
        let innateIndex = abilities.firstIndex(where: { $0.isInnate })
        if let innateIndex {
            let innate = abilities.remove(at: innateIndex)
            abilities.insert(innate, at: 0)
        }
        return abilities
    }
    
    private func fetchTalent(for name: String) -> Ability? {
        let ability = Ability.fetchByName(name: name, context: context)
        return ability
    }
}

#if DEBUG
#Preview {
    HeroDetailViewV2(hero: Hero.antimage)
        .environmentObject(ImageController.preview)
        .environment(\.managedObjectContext, PersistanceProvider.preview.container.viewContext)
}
#endif
