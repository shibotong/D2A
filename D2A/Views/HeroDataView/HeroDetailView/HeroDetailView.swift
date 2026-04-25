//
//  HeroDetailView.swift
//  App
//
//  Created by Shibo Tong on 14/5/2022.
//

import SwiftUI

struct HeroDetailView: View {
    @ObservedObject var viewModel: HeroDetailViewModel
    private let skillFrame: CGFloat = 30
    
    var body: some View {
        ZStack {
            ScrollView {
                HeroTitleView(heroID: viewModel.hero.heroID,
                              primaryAttribute: viewModel.hero.primaryAttribute,
                              displayName: viewModel.hero.localizedName,
                              heroComplexity: Int(viewModel.hero.complexity))
                abilitiesView
                    .padding(.horizontal, 5)
                Divider()
                VStack {
                    levelSlider
                    Divider()
                    HeroAttributesView(level: Int(viewModel.heroLevel), hero: viewModel.hero)
                    Divider()
                    HeroRoleView(carry: Int(viewModel.hero.roleCarry),
                                 disabler: Int(viewModel.hero.roleDisabler),
                                 escape: Int(viewModel.hero.roleEscape),
                                 support: Int(viewModel.hero.roleSupport),
                                 jungler: Int(viewModel.hero.roleJungler),
                                 pusher: Int(viewModel.hero.rolePusher),
                                 nuker: Int(viewModel.hero.roleNuker),
                                 durable: Int(viewModel.hero.roleDurable),
                                 initiator: Int(viewModel.hero.roleInitiator))
                    Divider()
                    HeroStatsView(level: Int(viewModel.heroLevel), hero: viewModel.hero)
                    Divider()
                    HeroTalentsView(talent10Left: viewModel.hero.talent1LeftName,
                                    talent10Right: viewModel.hero.talent1RightName,
                                    talent15Left: viewModel.hero.talent2LeftName,
                                    talent15Right: viewModel.hero.talent2RightName,
                                    talent20Left: viewModel.hero.talent3LeftName,
                                    talent20Right: viewModel.hero.talent3RightName,
                                    talent25Left: viewModel.hero.talent4LeftName,
                                    talent25Right: viewModel.hero.talent4RightName)
                }
                .padding(.horizontal)
            }
            .navigationTitle(viewModel.hero.localizedName)
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $viewModel.selectedAbility, content: { ability in
            NavigationView {
                AbilityView(heroName: viewModel.hero.heroName, ability: ability)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Close", systemImage: "xmark") {
                                viewModel.selectedAbility = nil
                            }
                        }
                    }
            }
        })
    }
    
    private var abilitiesView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(viewModel.abilities, id: \.id) { ability in
                    if ability.behavior != "Hidden" {
                        Button {
                            viewModel.selectedAbility = ability
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
        Slider(value: $viewModel.heroLevel, in: 1...30, step: 1) {
            Text("Level \(Int(viewModel.heroLevel))")
        } minimumValueLabel: {
            Text("\(Int(viewModel.heroLevel))")
        } maximumValueLabel: {
            Text("30")
        }
    }
}

 struct HeroDetailView_Preview: PreviewProvider {
    static var previews: some View {
        HeroDetailView(viewModel: HeroDetailViewModel(hero: PreviewData.PreviewHero.antimage))
            .environmentObject(PreviewData.environment)
    }
 }
