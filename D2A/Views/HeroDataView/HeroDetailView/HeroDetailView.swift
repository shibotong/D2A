//
//  HeroDetailView.swift
//  App
//
//  Created by Shibo Tong on 14/5/2022.
//

import SwiftUI

struct HeroDetailView: View {
    @ObservedObject var viewModel: HeroDetailViewModel
    @State var isPresented = false
    
    private let skillFrame: CGFloat = 30
    
    var body: some View {
        ZStack {
            ScrollView {
                HeroTitleView(heroID: viewModel.heroID, primaryAttribute: viewModel.primaryAttribute, displayName: viewModel.localizedName, heroComplexity: viewModel.complexity)
                abilitiesView
                    .padding(.horizontal, 5)
                Divider()
                VStack {
                    buildAttributes(hero: viewModel.hero.hero)
                    Divider()
                    HeroRoleView(carry: viewModel.carryValue, disabler: viewModel.disablerValue, escape: viewModel.escapeValue, support: viewModel.supportValue, jungler: viewModel.junglerValue, pusher: viewModel.pusherValue, nuker: viewModel.nukerValue, durable: viewModel.durableValue, initiator: viewModel.initiatorValue)
                    Divider()
                    HeroStatsView(hero: viewModel.hero.hero)
                    Divider()
                    HeroTalentsView(talent10Left: viewModel.talent1Left,
                                    talent10Right: viewModel.talent1Right,
                                    talent15Left: viewModel.talent2Left,
                                    talent15Right: viewModel.talent2Right,
                                    talent20Left: viewModel.talent3Left,
                                    talent20Right: viewModel.talent3Right,
                                    talent25Left: viewModel.talent4Left,
                                    talent25Right: viewModel.talent4Right)
                }
            }.navigationTitle(viewModel.hero.localizedName)
        }
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $viewModel.selectedAbility, content: { ability in
            AbilityView(heroName: viewModel.name, ability: ability)
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
    
    @ViewBuilder
    private func buildAttributes(hero: Hero) -> some View {
        VStack {
            HStack {
                Text("Attributes")
                    .font(.system(size: 15))
                    .bold()
                Spacer()
            }.padding(.bottom)
            VStack(spacing: 0) {
                HStack {
                    Text("Health")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(.secondaryLabel)
                    Spacer()
                    Text("\(hero.calculateHPLevel(level: viewModel.heroLevel))")
                        .font(.system(size: 15))
                        .bold()
                    Text("+ \(hero.calculateHPRegen(level: viewModel.heroLevel), specifier: "%.1f")")
                        .font(.system(size: 13))
                }
                buildManaHealthBar(total: hero.calculateHPLevel(level: viewModel.heroLevel), color: Color(UIColor.systemGreen))
            }
            VStack(spacing: 0) {
                HStack {
                    Text("Mana")
                        .font(.system(size: 15))
                        .bold()
                        .foregroundColor(.secondaryLabel)
                    Spacer()
                    Text("\(hero.calculateManaLevel(level: viewModel.heroLevel))")
                        .font(.system(size: 15))
                        .bold()
                    Text("+ \(hero.calculateMPRegen(level: viewModel.heroLevel), specifier: "%.1f")")
                        .font(.system(size: 13))
                }
                
                buildManaHealthBar(total: hero.calculateManaLevel(level: viewModel.heroLevel), color: Color(UIColor.systemBlue))
            }
            
            HStack {
                Spacer()
                HStack {
                    Image("hero_str")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("\(hero.calculateAttribute(level: viewModel.heroLevel, attr: .str))")
                        .font(.system(size: 18))
                        .bold()
                    Text("+ \(hero.gainStr, specifier: "%.1f")")
                        .font(.system(size: 13))
                }
                Spacer()
                HStack {
                    Image("hero_agi")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("\(hero.calculateAttribute(level: viewModel.heroLevel, attr: .agi))")
                        .font(.system(size: 18))
                        .bold()
                    Text("+ \(hero.gainAgi, specifier: "%.1f")")
                        .font(.system(size: 13))
                }
                Spacer()
                HStack {
                    Image("hero_int")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("\(hero.calculateAttribute(level: viewModel.heroLevel, attr: .int))")
                        .font(.system(size: 18))
                        .bold()
                    Text("+ \(hero.gainInt, specifier: "%.1f")")
                        .font(.system(size: 13))
                }
                Spacer()
            }
            Slider(value: $viewModel.heroLevel, in: 1...30, step: 1) {
                Text("Level \(Int(viewModel.heroLevel))")
            } minimumValueLabel: {
                Text("\(Int(viewModel.heroLevel))")
            } maximumValueLabel: {
                Text("30")
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func buildManaHealthBar(total: Int, color: Color) -> some View {
        GeometryReader { proxy in
            let rectangles = Double(total) / 250.00
            let numberOfRect = total / 250
            let spacer = (total % 250 == 0) ? numberOfRect : numberOfRect + 1
            let restWidth = proxy.size.width - CGFloat(spacer)
            let rectWidth = restWidth / rectangles
            
            HStack(spacing: 1) {
                ForEach(0..<numberOfRect, id: \.self) { _ in
                    Rectangle()
                        .frame(width: rectWidth)
                }
                Rectangle()
            }
            .frame(height: 10)
            .foregroundColor(color)
            .clipShape(Capsule())
        }
    }
}

 struct HeroDetailView_Preview: PreviewProvider {
    static var previews: some View {
        HeroDetailView(viewModel: HeroDetailViewModel(hero: PreviewData.PreviewHero.antimage, language: .english))
    }
 }
