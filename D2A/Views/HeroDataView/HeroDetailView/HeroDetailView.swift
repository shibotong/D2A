//
//  HeroDetailView.swift
//  App
//
//  Created by Shibo Tong on 14/5/2022.
//

import SwiftUI
import CoreData

struct HeroDetailView: View {
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    let hero: Hero
    let abilities: [Ability]
    
    @State var selectedAbility: Ability?
    @State var heroLevel = 1.00
    
    private let skillFrame: CGFloat = 30
    
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
        if horizontalSizeClass == .compact {
            iPhone
        } else {
            iPad
        }
    }
    
    private var iPad: some View {
        Text("abc")
        
    }
    
    private var iPhone: some View {
        ScrollView {
            HeroTitleView(heroID: hero.heroID,
                          primaryAttribute: hero.primaryAttribute,
                          displayName: hero.localizedName,
                          heroComplexity: Int(hero.complexity))
            abilitiesView
                .padding(.horizontal, 5)
            Divider()
            VStack {
                levelSlider
                Divider()
                attributesView
                Divider()
                roleView
                Divider()
                statsView
                Divider()
                talentsView
            }
            .padding(.horizontal)
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
    
    private var abilitiesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
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
                .padding(10)
            }
        }
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

 struct HeroDetailView_Preview: PreviewProvider {
    static var previews: some View {
        HeroDetailView(hero: PreviewData.PreviewHero.antimage)
            .environmentObject(PreviewData.environment)
    }
 }
