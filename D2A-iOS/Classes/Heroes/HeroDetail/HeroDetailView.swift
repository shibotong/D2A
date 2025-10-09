//
//  HeroDetailView.swift
//  D2A
//
//  Created by Shibo Tong on 27/7/2025.
//

import SwiftUI

struct HeroDetailView: View {
    
    @Environment(\.managedObjectContext) private var context
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    @State var heroLevel: Double = 1
    @State private var abilities: [Ability] = []
    @State private var selectedAbility: Ability?
    
    @State private var showFullLore = false
    
    let hero: Hero
    private let detailSpacing: CGFloat = 2
    
    var body: some View {
        List {
            //            VStack {
            //                Group {
            //                    levelSlider
            //                    HealthManaView(level: Int(heroLevel), hero: hero)
            //                }
            //                .padding()
            //                .background(Color.systemBackground)
            //                .clipShape(RoundedRectangle(cornerRadius: 5))
            //                stackBuilder(views: attributeCollection)
            //                stackBuilder(views: statsCollection)
            //                stackBuilder(views: talentsLoreCollection)
            //            }
            //            .padding(.horizontal)
            titleView
            abilitiesView
            levelSlider
            HealthManaView(level: Int(heroLevel), hero: hero)
                .listRowSeparator(.hidden)
            statsView
            loreView
        }
        .listStyle(.plain)
        .sheet(item: $selectedAbility, content: { ability in
            AbilityView(ability: ability)
        })
        .task {
            self.abilities = loadAbilities()
        }
    }
    
    private var abilitiesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(abilities) { ability in
                    AbilityImage(name: ability.name, isInnate: ability.isInnate)
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onTapGesture {
                            selectedAbility = ability
                        }
                }
            }
            .padding()
        }
        .listRowInsets(EdgeInsets())
    }
    
    private var levelSlider: some View {
        HStack {
            Text("\(Int(heroLevel))")
                .bold()
            Slider(value: $heroLevel, in: 1...30, step: 1)
            Text("30")
        }
        .listRowSeparator(.hidden)
    }
    
    private var loreView: some View {
        buildSection(title: "Lore") {
            VStack(alignment: .leading) {
                Text("\(hero.lore)")
                    .lineLimit(showFullLore ? nil : 10)
                Button(action: {
                    showFullLore.toggle()
                }, label: {
                    Text("Show more")
                })
            }
        }
    }
    
    private var titleView: some View {
        HStack(spacing: 16) {
            HeroImageViewV2(name: hero.heroNameLowerCase, type: .full)
                .frame(width: 100)
                .clipShape(.rect(cornerRadius: 16))
            VStack(alignment: .leading) {
                Text(hero.heroNameLocalized)
                    .font(.title2)
                Text("Melee")
                    .foregroundStyle(.secondary)
            }
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
    
    private var attributeCollection: some View {
        Group {
            buildAttribute(attribute: .str)
            buildAttribute(attribute: .agi)
            buildAttribute(attribute: .int)
        }
        .padding()
        .background(Color.systemBackground)
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
    
    @ViewBuilder
    func buildSection<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        Section {
            content()
        } header: {
            Text(title)
                .font(.title3)
                .bold()
                .foregroundStyle(.primary)
        }
        .listRowSeparator(.hidden)
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
    HeroDetailView(hero: Hero.antimage)
        .environmentObject(EnvironmentController.preview)
        .environment(\.managedObjectContext, PersistanceProvider.preview.container.viewContext)
}
#endif
