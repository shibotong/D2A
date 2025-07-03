//
//  HeroDetailView.swift
//  App
//
//  Created by Shibo Tong on 14/5/2022.
//

import SwiftUI

struct HeroDetailView: View {
    @StateObject var vm: HeroDetailViewModel
    @Environment(\.horizontalSizeClass) var horizontal
    @State private var heroLevel = 1.00

    var body: some View {
        ZStack {
            if let hero = vm.hero {
                buildMainBody(hero: hero)
            } else if vm.loadingHero {
                LoadingView()
            } else {
                Text("Cannot find hero")
                    .font(.caption)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            HStack {
                if let previousID = vm.previousHeroID {
                    Button {
                        vm.heroID = previousID
                    } label: {
                        HStack(spacing: 0) {
                            Image(systemName: "chevron.left")
                            HeroImageView(heroID: previousID, type: .icon)
                                .frame(width: 25, height: 25)
                        }
                    }
                }
                if let nextID = vm.nextHeroID {
                    Button {
                        vm.heroID = nextID
                    } label: {
                        HStack(spacing: 0) {
                            HeroImageView(heroID: nextID, type: .icon)
                                .frame(width: 25, height: 25)
                            Image(systemName: "chevron.right")
                        }
                    }
                }
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

    @ViewBuilder private func buildMainBody(hero: Hero) -> some View {
        if horizontal == .compact {
            buildCompactBody(hero: hero)
        } else {
            buildRegularBody(hero: hero)
        }
    }

    @ViewBuilder private func buildRegularBody(hero: Hero) -> some View {
        VStack(spacing: 0) {
            buildTitle(hero: hero)
            HStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        AttributesSectionView(hero: hero, level: Int(heroLevel))
                        Divider()
                        buildStats(hero: hero)
                        if let roles = hero.roles?.allObjects as? [Role] {
                            Divider()
                            buildRoles(roles: roles)
                        }
                        if let talents = hero.talents?.allObjects as? [Talent] {
                            Divider()
                            buildTalent(talent: talents)
                        }
                    }.padding()
                }
                Divider()
                if let selectedAbility = vm.selectedAbility {
                    AbilityView(
                        viewModel: AbilityViewModel(heroID: vm.heroID, ability: selectedAbility))
                }
            }
        }
    }

    @ViewBuilder private func buildCompactBody(hero: Hero) -> some View {
        ScrollView {
            buildTitle(hero: hero)
            ScrollView(.horizontal, showsIndicators: false) {
                buildAbilities(navigation: true)
            }.padding(.horizontal, 5)
            Divider()
            buildHeroDetails(hero: hero)
        }.navigationTitle(hero.heroNameLocalized)
    }

    @ViewBuilder private func buildTitle(hero: Hero) -> some View {
        if horizontal == .compact {
            HeroImageView(heroID: Int(hero.id), type: .full)
                .overlay(
                    LinearGradient(
                        colors: [
                            Color(.black).opacity(0),
                            Color(.black).opacity(1),
                        ],
                        startPoint: .top,
                        endPoint: .bottom)
                )
                .overlay(
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Spacer()
                            HStack {
                                Image(hero.attribute.image)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text(LocalizedStringKey(hero.displayName ?? ""))
                                    .font(.system(size: 30))
                                    .bold()
                                    .foregroundColor(.white)
                                Text("\(Int(hero.id))")
                                    .font(.caption2)
                                    .foregroundColor(.white.opacity(0.5))
                                Spacer()
                                buildComplexity(hero.complexity)
                            }
                        }
                        Spacer()
                    }.padding(.leading))
        } else {
            HStack {
                HeroImageView(heroID: Int(hero.id), type: .full)
                Image(hero.attribute.image)
                    .resizable()
                    .frame(width: 25, height: 25)
                Text(LocalizedStringKey(hero.displayName ?? ""))
                    .font(.body)
                    .bold()
                Text("\(Int(hero.id))")
                    .font(.caption2)
                    .foregroundColor(.label.opacity(0.5))
                buildComplexity(hero.complexity)
                Spacer()
                buildAbilities(navigation: false)
            }
            .frame(height: 50)
            .padding()
            .background(Color.secondarySystemBackground)
        }
    }

    @ViewBuilder private func buildComplexity(_ heroComplexity: Int16) -> some View {
        let color: Color = horizontal == .compact ? .white : .label
        HStack {
            ForEach(1..<4) { complexity in
                if complexity <= heroComplexity {
                    RoundedRectangle(cornerRadius: 3)
                        .frame(width: 15, height: 15)
                        .foregroundColor(color)
                        .rotationEffect(.degrees(45))
                } else {
                    RoundedRectangle(cornerRadius: 3)
                        .stroke()
                        .frame(width: 15, height: 15)
                        .foregroundColor(color)
                        .rotationEffect(.degrees(45))
                }
            }
        }
    }

    @ViewBuilder private func buildAbilities(navigation: Bool) -> some View {
        HStack {
            ForEach(vm.abilities) { ability in
                if navigation {
                    NavigationLink(
                        destination: AbilityView(
                            viewModel: AbilityViewModel(heroID: vm.heroID, ability: ability))
                    ) {
                        AbilityImage(
                            viewModel: AbilityImageViewModel(
                                name: ability.name, urlString: ability.imageURL)
                        )
                        .frame(width: 30, height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .accessibilityIdentifier(ability.name ?? "")
                    }
                } else {
                    Button {
                        vm.selectedAbility = ability
                    } label: {
                        AbilityImage(
                            viewModel: AbilityImageViewModel(
                                name: ability.name, urlString: ability.imageURL)
                        )
                        .frame(width: 30, height: 30)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }.accessibilityIdentifier(ability.name ?? "")
                }
            }
        }
        .padding(10)
    }

    @ViewBuilder private func buildHeroDetails(hero: Hero) -> some View {
        VStack {
            AttributesSectionView(hero: hero, level: Int(heroLevel))
            Divider()
            if let roles = hero.roles?.allObjects as? [Role] {
                buildRoles(roles: roles)
                Divider()
            }
            buildStats(hero: hero)
            Divider()
            if let talents = hero.talents?.allObjects as? [Talent] {
                buildTalent(talent: talents)
            }
        }
    }

    @ViewBuilder private func buildTalent(talent: [Talent]) -> some View {
        VStack {
            HStack {
                Text("Talents")
                    .font(.system(size: 15))
                    .bold()
                Spacer()
            }.padding(.leading)
            buildLevelTalent(talent: talent, level: 4)
            Divider()
            buildLevelTalent(talent: talent, level: 3)
            Divider()
            buildLevelTalent(talent: talent, level: 2)
            Divider()
            buildLevelTalent(talent: talent, level: 1)
        }
    }

    @ViewBuilder private func buildLevelTalent(talent: [Talent], level: Int) -> some View {
        GeometryReader { proxy in
            HStack(spacing: 5) {
                if let leftSideTalent = talent.first(where: { $0.slot == level * 2 - 1 }) {
                    let abilityId = leftSideTalent.abilityId
                    Text(vm.fetchTalentName(id: abilityId))
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
                    let abilityId = rightSideTalent.abilityId
                    Text(vm.fetchTalentName(id: abilityId))
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

    @ViewBuilder private func buildRoles(roles: [Role]) -> some View {
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
                        buildRole(role: "Carry", roles: roles)
                        buildRole(role: "Disabler", roles: roles)
                        buildRole(role: "Escape", roles: roles)
                    }.frame(width: width)
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        buildRole(role: "Support", roles: roles)
                        buildRole(role: "Jungler", roles: roles)
                        buildRole(role: "Pusher", roles: roles)
                    }.frame(width: width)
                    VStack(alignment: .leading, spacing: verticalSpacing) {
                        buildRole(role: "Nuker", roles: roles)
                        buildRole(role: "Durable", roles: roles)
                        buildRole(role: "Initiator", roles: roles)
                    }.frame(width: width)
                }
                .padding(.horizontal, horizontalSpacing)
            }
            .frame(height: 120)
        }
    }

    @ViewBuilder private func buildRole(role: String, roles: [Role]) -> some View {
        let filterdRole = roles.first { $0.roleId == role.uppercased() }
        RoleView(title: role, level: filterdRole?.level ?? 0.0)
    }

    @ViewBuilder private func buildStats(hero: Hero) -> some View {
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
                    buildStatDetail(
                        image: "icon_damage",
                        value:
                            "\(hero.calculateAttackByLevel(level: heroLevel, isMin: true))-\(hero.calculateAttackByLevel(level: heroLevel, isMin: false))"
                    )
                    buildStatDetail(image: "icon_attack_time", value: "\(hero.attackRate)")
                    buildStatDetail(image: "icon_attack_range", value: "\(hero.attackRange)")
                    buildStatDetail(
                        image: "icon_projectile_speed", value: "\(hero.projectileSpeed)")
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Defense")
                        .font(.system(size: 15))
                    buildStatDetail(
                        image: "icon_armor",
                        value: String(format: "%.1f", hero.calculateArmorByLevel(level: heroLevel)))
                    buildStatDetail(image: "icon_magic_resist", value: "\(hero.baseMr)%")
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Mobility")
                        .font(.system(size: 15))
                    buildStatDetail(image: "icon_movement_speed", value: "\(hero.moveSpeed)")
                    buildStatDetail(image: "icon_turn_rate", value: "\(hero.turnRate)")
                    buildStatDetail(
                        image: "icon_vision",
                        value: "\(Int(hero.visionDaytimeRange))/\(Int(hero.visionNighttimeRange))")
                }
                Spacer()
            }
        }
    }

    @ViewBuilder private func buildStatDetail(image: String, value: String) -> some View {
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
}

struct HeroDetailView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                HeroDetailView(vm: HeroDetailViewModel(heroID: 1))
                    .environment(\.horizontalSizeClass, .regular)
            }
            .previewDevice(.iPhone)

            NavigationView {
                EmptyView()
                HeroDetailView(vm: HeroDetailViewModel(heroID: 1))
                    .environment(\.horizontalSizeClass, .regular)
            }
            .previewDevice(.iPad)
        }
    }
}
