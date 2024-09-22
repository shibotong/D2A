//
//  HeroDetailViewV3.swift
//  D2A
//
//  Created by Shibo Tong on 22/9/2024.
//

import SwiftUI

struct HeroDetailViewV3: View {
    
    @Environment(\.managedObjectContext) var context
    @Environment(\.horizontalSizeClass) var horizontal
    
    let hero: Hero
    @State private var heroLevel: Double = 1
    @State private var selectedAbility: Ability?
    @State private var talentAbilities: [Ability] = []
    
    var body: some View {
        Group {
            if horizontal == .compact {
                iPhone
            } else {
                iPad
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationTitle(hero.heroNameLocalized)
        .onAppear {
            selectedAbility = hero.allAbilities.first
        }
        .task {
            guard let talentIDs = hero.talents?.map({ $0.abilityID }) else { return }
            talentAbilities = Ability.fetchAbilities(ids: talentIDs, viewContext: context)
        }
    }
    
    private var iPhone: some View {
        ScrollView {
            titleiPhone
            ScrollView(.horizontal, showsIndicators: false) {
                abilities
            }
            Divider()
            attributes
            Divider()
            roles
            Divider()
            stats
            Divider()
            talents
        }
    }
    
    private var iPad: some View {
        VStack(spacing: 0) {
            titleiPad
            HStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        attributes
                        Divider()
                        roles
                        Divider()
                        stats
                        Divider()
                        talents
                    }.padding()
                }
                Divider()
                if let selectedAbility {
                    AbilityView(ability: selectedAbility,
                                heroName: hero.heroNameLowerCase)
                }
            }
        }
    }
    
    private var talents: some View {
        VStack {
            HStack {
                Text("Talents")
                    .font(.system(size: 15))
                    .bold()
                Spacer()
            }.padding(.leading)
            buildLevelTalent(talent: hero.talents ?? [], level: 4)
            Divider()
            buildLevelTalent(talent: hero.talents ?? [], level: 3)
            Divider()
            buildLevelTalent(talent: hero.talents ?? [], level: 2)
            Divider()
            buildLevelTalent(talent: hero.talents ?? [], level: 1)
        }
    }
    
    private var slider: some View {
        Slider(value: $heroLevel, in: 1...30, step: 1) {
            Text("Level \(Int(heroLevel))")
        } minimumValueLabel: {
            Text("\(Int(heroLevel))")
        } maximumValueLabel: {
            Text("30")
        }
        .padding(.horizontal)
    }
    
    private var stats: some View {
        VStack {
            HStack {
                Text("Stats")
                    .font(.system(size: 15))
                    .bold()
                Spacer()
            }.padding(.leading)
            HStack(alignment: .top) {
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Attack")
                        .font(.system(size: 15))
                    buildStatDetail(image: "icon_damage",
                                    value: "\(hero.calculateAttackByLevel(level: heroLevel, isMin: true))-\(hero.calculateAttackByLevel(level: heroLevel, isMin: false))")
                    buildStatDetail(image: "icon_attack_time", value: "\(hero.attackRate)")
                    buildStatDetail(image: "icon_attack_range", value: "\(hero.attackRange)")
                    buildStatDetail(image: "icon_projectile_speed", value: "\(hero.projectileSpeed)")
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Defense")
                        .font(.system(size: 15))
                    buildStatDetail(image: "icon_armor", value: String(format: "%.1f", hero.calculateArmorByLevel(level: heroLevel)))
                    buildStatDetail(image: "icon_magic_resist", value: "\(hero.baseMr)%")
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Mobility")
                        .font(.system(size: 15))
                    buildStatDetail(image: "icon_movement_speed", value: "\(hero.moveSpeed)")
                    buildStatDetail(image: "icon_turn_rate", value: "\(hero.turnRate)")
                    buildStatDetail(image: "icon_vision", value: "\(Int(hero.visionDaytimeRange))/\(Int(hero.visionNighttimeRange))")
                }
                Spacer()
            }
        }
    }
    
    private var roles: some View {
        VStack {
            HStack {
                Text("Roles")
                    .font(.system(size: 15))
                    .bold()
                Spacer()
            }.padding(.leading)
            GeometryReader { proxy in
                let horizontalSpacing: CGFloat = 32
                let verticalSpacing: CGFloat = 8
                let width = (proxy.size.width - horizontalSpacing * 4) / 3
                HStack(spacing: horizontalSpacing) {
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        buildRole(name: "Carry")
                        buildRole(name: "Disabler")
                        buildRole(name: "Escape")
                    }.frame(width: width)
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        buildRole(name: "Support")
                        buildRole(name: "Jungler")
                        buildRole(name: "Pusher")
                    }.frame(width: width)
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        buildRole(name: "Nuker")
                        buildRole(name: "Durable")
                        buildRole(name: "Initiator")
                    }.frame(width: width)
                }
                .padding(.horizontal, horizontalSpacing)
            }
            .frame(height: 120)
        }
    }
    
    private var attributes: some View {
        VStack {
            HStack {
                Text("Attributes")
                    .font(.system(size: 15))
                    .bold()
                Spacer()
            }.padding(.bottom)
            buildBar(type: .hp)
            buildBar(type: .mana)
            HStack {
                Spacer()
                buildAttribute(type: .str)
                Spacer()
                buildAttribute(type: .agi)
                Spacer()
                buildAttribute(type: .int)
                Spacer()
            }
            slider
        }
        .padding(.horizontal)
    }
    
    private var titleiPad: some View {
        HStack {
            HeroImageView(heroID: Int(hero.id), type: .full)
            AttributeImage(attribute: HeroAttribute(rawValue: hero.primaryAttr ?? ""))
                .frame(width: 25, height: 25)
            Text(LocalizedStringKey(hero.displayName ?? ""))
                .font(.body)
                .bold()
            Text("\(Int(hero.id))")
                .font(.caption2)
                .foregroundColor(.label.opacity(0.5))
            complexity
            Spacer()
            abilities
        }
        .frame(height: 50)
        .padding()
        .background(Color.secondarySystemBackground)
    }
    
    private var titleiPhone: some View {
        HeroImageView(heroID: Int(hero.id), type: .full)
            .overlay(
                LinearGradient(colors: [Color(.black).opacity(0),
                                        Color(.black).opacity(1)],
                               startPoint: .top,
                               endPoint: .bottom))
            .overlay(HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Spacer()
                    HStack {
                        AttributeImage(attribute: HeroAttribute(rawValue: hero.primaryAttr ?? ""))
                            .frame(width: 25, height: 25)
                        Text(hero.heroNameLocalized)
                            .font(.system(size: 30))
                            .bold()
                            .foregroundColor(.white)
                        Text("\(Int(hero.id))")
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.5))
                        Spacer()
                        complexity
                    }
                }
                Spacer()
            }.padding(.leading))
    }
    
    private var abilities: some View {
        HStack {
            ForEach(hero.allAbilities) { ability in
                if horizontal == .compact {
                    NavigationLink(destination: AbilityView(ability: ability, heroName: hero.heroNameLowerCase)) {
                        AbilityImage(viewModel: AbilityImageViewModel(name: ability.name, urlString: ability.imageURL))
                            .frame(width: 30, height: 30)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .accessibilityIdentifier(ability.name ?? "")
                    }
                } else {
                    Button {
                        selectedAbility = ability
                    } label: {
                        AbilityImage(viewModel: AbilityImageViewModel(name: ability.name, urlString: ability.imageURL))
                            .frame(width: 30, height: 30)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .accessibilityIdentifier(ability.name ?? "")
                    }
                }
            }
        }
        .padding(.horizontal, 4)
    }
    
    private var complexity: some View {
        HStack {
            ForEach(1..<4) { complexity in
                Group {
                    if complexity <= hero.complexity {
                        RoundedRectangle(cornerRadius: 3)
                    } else {
                        RoundedRectangle(cornerRadius: 3)
                            .stroke()
                    }
                }
                
                .frame(width: 15, height: 15)
                .foregroundColor(horizontal == .compact ? .white : .label)
                .rotationEffect(.degrees(45))
            }
        }
    }
    
    @ViewBuilder 
    private func buildRole(name: String) -> some View {
        let role = hero.fetchRole(role: name)
        RoleView(title: name, level: role.level)
    }
    
    @ViewBuilder
    private func buildBar(type: Hero.HeroHPMana) -> some View {
        let total = hero.calculateHPManaByLevel(level: 1, type: type)
        let barColor = type == .hp ? Color(UIColor.systemGreen) : Color(UIColor.systemBlue)
        VStack(spacing: 0) {
            HStack {
                Text(LocalizedStringKey(type.rawValue))
                    .font(.system(size: 15))
                    .bold()
                    .foregroundColor(.secondaryLabel)
                Spacer()
                Text("\(total)")
                    .font(.system(size: 15))
                    .bold()
                Text("+ \(hero.calculateHPManaRegenByLevel(level: heroLevel, type: type), specifier: "%.1f")")
                    .font(.system(size: 13))
            }
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
                .foregroundColor(barColor)
                .clipShape(Capsule())
            }
        }
    }
    
    @ViewBuilder 
    private func buildAttribute(type: HeroAttribute) -> some View {
        let gain = hero.getGain(type: type)
        HStack {
            AttributeImage(attribute: type)
                .frame(width: 15, height: 15)
            Text("\(hero.calculateAttribute(level: heroLevel, attr: type))")
                .font(.system(size: 18))
                .bold()
            Text("+ \(gain, specifier: "%.1f")")
                .font(.system(size: 13))
        }
    }
    
    @ViewBuilder 
    private func buildStatDetail(image: String, value: String) -> some View {
        HStack {
            Image(image)
                .renderingMode(.template)
                .resizable()
                .frame(width: 15, height: 15)
                .foregroundColor(Color(uiColor: UIColor.label))
            Text(value)
                .font(.system(size: 15))
        }
    }
    
    @ViewBuilder 
    private func buildLevelTalent(talent: [HeroTalent], level: Int) -> some View {
        GeometryReader { proxy in
            HStack(spacing: 5) {
                if let leftSideTalent = talent.first(where: { $0.slot == level * 2 - 1 }) {
                    talentText(talent: leftSideTalent)
                        .font(.system(size: 10))
                        .frame(width: (proxy.size.width - 30) / 2)
                } else {
                    Text("No Talent")
                }
                Text("\(5 + 5 * level)")
                    .font(.system(size: 10))
                    .bold()
                    .padding(5)
                    .frame(width: 30, height: 30)
                    .background(Circle().stroke().foregroundColor(.yellow))
                if let rightSideTalent = talent.first(where: { $0.slot == level * 2 - 2 }) {
                    talentText(talent: rightSideTalent)
                        .font(.system(size: 10))
                        .frame(width: (proxy.size.width - 30) / 2)
                } else {
                    Text("No Talent")
                }
            }
        }
        .frame(height: 30)
        .padding(.horizontal)
    }
    
    @ViewBuilder
    private func talentText(talent: HeroTalent) -> some View {
        if let talentAbility = talentAbilities.first(where: { $0.abilityID == talent.abilityID }),
           let talentDisplayName = talentAbility.localisation()?.displayName {
            Text(talentDisplayName)
        } else {
            Text("No Talent")
        }
    }
}

#Preview {
    let previewContext = PersistenceController.preview.container.viewContext
    let hero = Hero(context: previewContext)
    hero.attackRange = 1800
    hero.attackRate = 1
    hero.attackType = "Melee"
    hero.baseAgi = 1
    hero.baseInt = 1
    hero.baseStr = 1
    hero.baseArmor = 1
    hero.baseAttackMax = 10
    hero.baseAttackMin = 5
    hero.baseHealth = 10
    hero.baseHealthRegen = 10
    hero.baseMana = 100
    hero.baseManaRegen = 100
    hero.baseMr = 25
    hero.complexity = 3
    hero.displayName = "Antimage"
    hero.gainAgi = 2
    hero.gainInt = 2
    hero.gainStr = 2
    hero.id = 1
    let ability = Ability(context: previewContext)
    ability.name = "antimage_mana_break"
    ability.abilityID = 1
    ability.mc = "10"
    
    let localisation = AbilityLocalisation(language: "ENGLISH", displayName: "Antimage Mana Break", lore: "A modified technique of the Turstarkuri monks' peaceful ways is to turn magical energies on their owner.", description: "Burns an opponent's mana on each attack and deals damage equal to a percentage of the mana burnt. Enemies with no mana left are temporarily slowed.")
    ability.localisations = [localisation]
    hero.addToAbilities(ability)
    return HeroDetailViewV3(hero: hero)
}
