//
//  HeroDetailView.swift
//  D2A
//
//  Created by Shibo Tong on 27/7/2025.
//

import SwiftUI

struct HeroDetailView: View {
    
    // MARK: - Variables
    @Environment(\.managedObjectContext) private var context
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @State var heroLevel: Double = 1
    @State private var abilities: [Ability] = []
    @State private var selectedAbility: Ability?
    
    @State private var showFullLore = false
    
    let hero: Hero
    private let detailSpacing: CGFloat = 2
    
    // MARK: - Views
    var body: some View {
        List {
            titleView
            abilitiesView
            levelSlider
            HealthManaView(level: Int(heroLevel), hero: hero)
                .listRowSeparator(.hidden)
            attributeView
            statsView
            talentsView
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
    
    @ViewBuilder
    private var attributeView: some View {
        buildSection(title: "Attributes") {
            if horizontalSizeClass == .regular {
                HStack {
                    horizontalSection {
                        attributeBuilder(attribute: .str)
                    }
                    horizontalSection {
                        attributeBuilder(attribute: .agi)
                    }
                    horizontalSection {
                        attributeBuilder(attribute: .int)
                    }
                }
            } else {
                attributeBuilder(attribute: .str)
                attributeBuilder(attribute: .agi)
                attributeBuilder(attribute: .int)
            }
        }
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
    
    @ViewBuilder
    private var talentsView: some View {
        if let talents = hero.talents {
            buildSection(title: "Talents") {
                if horizontalSizeClass == .regular {
                    HStack {
                        horizontalSection {
                            buildTalents(level: 2, talents: talents)
                            buildTalents(level: 1, talents: talents)
                        }
                        horizontalSection {
                            buildTalents(level: 4, talents: talents)
                            buildTalents(level: 3, talents: talents)
                        }
                    }
                } else {
                    buildTalents(level: 4, talents: talents)
                    buildTalents(level: 3, talents: talents)
                    buildTalents(level: 2, talents: talents)
                    buildTalents(level: 1, talents: talents)
                }
            }
        }
    }
    
    // MARK: - ViewBuilders
    
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
        }
    }
    
    @ViewBuilder
    func horizontalSection<Content: View>(@ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
    
    @ViewBuilder
    private func attributeBuilder(attribute: HeroAttribute) -> some View {
        let gain = hero.getGain(type: attribute)
        if horizontalSizeClass == .regular {
            VStack(alignment: .leading) {
                buildSectionTitle(icon: attribute.image, title: attribute.displayName, renderMode: .original)
                HStack {
                    Text("\(hero.calculateAttribute(level: heroLevel, attr: attribute))")
                        .bold()
                    Text("+ \(gain, specifier: "%.1f")")
                }
            }
        } else {
            HStack {
                buildSectionTitle(icon: attribute.image, title: attribute.displayName, renderMode: .original)
                Spacer()
                Text("\(hero.calculateAttribute(level: heroLevel, attr: attribute))")
                    .bold()
                Text("+ \(gain, specifier: "%.1f")")
            }
        }
    }
    
    // MARK: - Functions
    
    private func fetchTalent(for name: String) -> Ability? {
        let ability = Ability.fetchByName(name: name, context: context)
        return ability
    }
    
    private func loadAbilities() -> [Ability] {
        guard let abilityNames = hero.abilities else {
            return []
        }
        var abilities = abilityNames.compactMap { Ability.fetchByName(name: $0, context: context) }
        
        let innateIndex = abilities.firstIndex(where: { $0.isInnate })
        if let innateIndex {
            let innate = abilities.remove(at: innateIndex)
            abilities.insert(innate, at: 0)
        }
        return abilities
    }
}

#if DEBUG
#Preview {
    HeroDetailView(hero: Hero.antimage)
        .environmentObject(EnvironmentController.preview)
        .environment(\.managedObjectContext, PersistanceProvider.preview.container.viewContext)
}
#endif
