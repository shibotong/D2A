//
//  HeroDetailViewV3.swift
//  D2A
//
//  Created by Shibo Tong on 22/9/2024.
//

import SwiftUI

struct HeroDetailViewV3: View {
    
    @State var hero: Hero
    @State private var heroLevel: Double = 1
    
    var body: some View {
        iPhone
    }
    
    private var iPhone: some View {
        ScrollView {
            title
            abilities
            Divider()
            attributes
            Divider()
            roles
            Divider()
            stats
            Divider()
            
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
                        buildRole(role: "Carry", roles: hero.roles ?? [])
                        buildRole(role: "Disabler", roles: hero.roles ?? [])
                        buildRole(role: "Escape", roles: hero.roles ?? [])
                    }.frame(width: width)
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        buildRole(role: "Support", roles: hero.roles ?? [])
                        buildRole(role: "Jungler", roles: hero.roles ?? [])
                        buildRole(role: "Pusher", roles: hero.roles ?? [])
                    }.frame(width: width)
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        buildRole(role: "Nuker", roles: hero.roles ?? [])
                        buildRole(role: "Durable", roles: hero.roles ?? [])
                        buildRole(role: "Initiator", roles: hero.roles ?? [])
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
    
    private var title: some View {
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
                        Text(LocalizedStringKey(hero.displayName ?? ""))
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(hero.allAbilities) { ability in
                    NavigationLink(destination: AbilityView(ability: ability, heroName: hero.heroNameLowerCase)) {
                        AbilityImage(viewModel: AbilityImageViewModel(name: ability.name, urlString: ability.imageURL))
                            .frame(width: 30, height: 30)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .accessibilityIdentifier(ability.name ?? "")
                    }
                }
            }
            .padding(.horizontal, 4)
        }
    }
    
    private var complexity: some View {
        HStack {
            ForEach(1..<4) { complexity in
                if complexity <= hero.complexity {
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(45))
                } else {
                    RoundedRectangle(cornerRadius: 3)
                        .stroke()
                        .frame(width: 15, height: 15)
                        .foregroundColor(.white)
                        .rotationEffect(.degrees(45))
                }
            }
        }
    }
    
    @ViewBuilder 
    private func buildRole(role: String, roles: [HeroRole]) -> some View {
        let filterdRole = roles.first { $0.roleId == role.uppercased() }
        RoleView(title: role, level: filterdRole?.level ?? 0)
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
//                    let abilityId = leftSideTalent.abilityId
                    Text(leftSideTalent.abilityID.description)
                        .font(.system(size: 10))
                        .frame(width: (proxy.size.width - 40) / 2)
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
//                    let abilityId = rightSideTalent.abilityId
                    Text(rightSideTalent.abilityID.description)
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
