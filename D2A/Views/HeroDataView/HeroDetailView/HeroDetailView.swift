//
//  HeroDetailView.swift
//  App
//
//  Created by Shibo Tong on 14/5/2022.
//

import SwiftUI
import CoreData

struct HeroDetailView: View {
        
    let hero: Hero
    let abilities: [Ability]
    
    @State var selectedAbility: Ability?
    @State var heroLevel = 1.00
    
    private let skillFrame: CGFloat = 40
    
    init(hero: Hero, abilities: [Ability]) {
        self.hero = hero
        self.abilities = abilities
    }
    
    init(hero: any HeroProtocol) {
        self.init(hero: hero.hero,
                  abilities: hero.heroAbilities)
    }
    
    init(heroID: Int,
         context: NSManagedObjectContext = PersistenceProvider.shared.mainContext,
         persistence: DataPersistenceService = .shared) {
        let hero = (try? persistence.fetch(heroID: heroID, context: context)) ?? Hero(context: context)
        self.init(hero: hero)
    }
    
    var body: some View {
        ScrollView {
            titleView
            ScrollView(.horizontal, showsIndicators: false) {
                abilityStack
            }
            Divider()
            constantStack
        }
        .navigationTitle(hero.localizedName)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedAbility, content: { ability in
            NavigationView {
                AbilityView(heroName: hero.heroName, ability: ability)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Close", systemImage: "xmark") {
                                selectedAbility = nil
                            }
                        }
                    }
            }
        })
    }
    
    private var titleView: some View {
        HeroTitleView(heroID: hero.heroID,
                      primaryAttribute: hero.primaryAttribute,
                      displayName: hero.localizedName,
                      heroComplexity: Int(hero.complexity))
    }
    
    private var constantStack: some View {
        VStack {
            levelSlider
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 375, maximum: 700), alignment: .top)]) {
                Group {
                    attributesView
                    roleView
                    statsView
                    talentsView
                }
                .frame(height: 200)
            }
        }
        .padding(.horizontal)
    }
    
    private var abilityStack: some View {
        HStack(spacing: 12) {
            ForEach(abilities, id: \.id) { ability in
                if ability.behavior != "Hidden" {
                    Button {
                        selectedAbility = ability
                    } label: {
                        AbilityImage(name: ability.name ?? "")
                            .frame(width: skillFrame, height: skillFrame)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
    }
    
    private var levelSlider: some View {
        Slider(value: $heroLevel, in: 1...30, step: 1) {
            Text("Level \(Int(heroLevel))")
        } minimumValueLabel: {
            Text("\(Int(heroLevel))")
        } maximumValueLabel: {
            Text("30")
        }
    }
    
    private var attributesView: some View {
        HeroAttributesView(level: Int(heroLevel), hero: hero)
    }
    
    private var roleView: some View {
        HeroRoleView(carry: Int(hero.roleCarry),
                     disabler: Int(hero.roleDisabler),
                     escape: Int(hero.roleEscape),
                     support: Int(hero.roleSupport),
                     jungler: Int(hero.roleJungler),
                     pusher: Int(hero.rolePusher),
                     nuker: Int(hero.roleNuker),
                     durable: Int(hero.roleDurable),
                     initiator: Int(hero.roleInitiator))
    }
    
    private var statsView: some View {
        HeroStatsView(level: Int(heroLevel), hero: hero)
    }
    
    private var talentsView: some View {
        HeroTalentsView(talent10Left: hero.talent1LeftName,
                        talent10Right: hero.talent1RightName,
                        talent15Left: hero.talent2LeftName,
                        talent15Right: hero.talent2RightName,
                        talent20Left: hero.talent3LeftName,
                        talent20Right: hero.talent3RightName,
                        talent25Left: hero.talent4LeftName,
                        talent25Right: hero.talent4RightName)
    }
}

#if DEBUG
struct HeroDetailView_Preview: PreviewProvider {
    static var previews: some View {
        HeroDetailView(hero: PreviewData.PreviewHero.antimage)
            .environmentObject(PreviewData.environment)
            .environment(\.horizontalSizeClass, .regular)
    }
}
#endif
