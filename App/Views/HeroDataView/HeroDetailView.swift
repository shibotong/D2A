//
//  HeroDetailView.swift
//  App
//
//  Created by Shibo Tong on 14/5/2022.
//

import SwiftUI
import SDWebImageSwiftUI
import BottomSheet
import AVKit

struct HeroDetailView: View {
    @ObservedObject var vm: HeroDetailViewModel
    @EnvironmentObject var env: DotaEnvironment
    @EnvironmentObject var database: HeroDatabase
    @State var heroLevel = 1.00
    
    var body: some View {
        ScrollView {
            buildTitle(hero: vm.hero)
            buildSkills()
                .padding(.horizontal, 5)
            Divider()
            buildHeroDetail()
            Spacer()
        }
        .navigationTitle(vm.hero.localizedName)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $vm.selectedAbility) { ability in
            NavigationView {
                AbilityView(ability: ability.ability, heroID: vm.heroID, abilityName: ability.abilityName)
                
            }
        }
    }
    
    @ViewBuilder private func buildHeader() -> some View {
        buildTitle(hero: vm.hero)
        buildSkills()
            .padding(.horizontal, 5)
    }
    
    @ViewBuilder private func buildTitle(hero: Hero) -> some View {
        HeroImageView(heroID: hero.id, type: .full)
            .overlay(LinearGradient(colors: [Color(.black).opacity(0), Color(.black).opacity(1)], startPoint: .top, endPoint: .bottom))
            .overlay(HStack {
                VStack(alignment: .leading, spacing: 3) {
                    Spacer()
                    HStack {
                        Image("hero_\(hero.primaryAttr)")
                            .resizable()
                            .frame(width: 25, height: 25)
                        Text(LocalizedStringKey(hero.localizedName))
                            .font(.custom(fontString, size: 30))
                            .bold()
                            .foregroundColor(.white)
                    }
                }
                Spacer()
            }.padding(.leading))
    }
    
    @ViewBuilder private func buildSkills() -> some View {
        let skillFrame: CGFloat = 30
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(vm.heroAbility.abilities.filter { ability in
                    let containHidden = ability.contains("hidden")
                    let containEmpty = ability.contains("empty")
//                    let abilityData = vm.fetchAbility(name: ability)
//                    let isScepter = database.hasScepter(ability: abilityData, heroID: vm.heroID)
//                    let isShard = database.hasShard(ability: abilityData, heroID: vm.heroID)
//                    let hasLore = abilityData.lore != nil
//                    var emptyLore = false
//                    if hasLore {
//                        let lore = abilityData.lore!
//                        emptyLore = lore.isEmpty
//                    }
//                    let isPassive = abilityData.behavior?.transformString() == "Passive"
                    return !containHidden && !containEmpty
                }, id: \.self) { abilityName in
                    let ability = vm.fetchAbility(name: abilityName)
                    let parsedimgURL = ability.img!.replacingOccurrences(of: "_md", with: "").replacingOccurrences(of: "images/abilities", with: "images/dota_react/abilities")
                    Button {
                        self.vm.selectedAbility = AbilityContainer(ability: vm.fetchAbility(name: abilityName), heroID: vm.heroID, abilityName: abilityName)
                    } label: {
                        WebImage(url: URL(string: "https://cdn.cloudflare.steamstatic.com\(parsedimgURL)"))
                            .resizable()
                            .renderingMode(.original)
                            .indicator(.activity)
                            .transition(.fade)
                            .aspectRatio(contentMode: .fit)
                            .frame(width: skillFrame)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            .padding(10)
        }
    }
    
    @ViewBuilder private func buildAbility(ability: Ability) -> some View {
        if let img = ability.img{
            let parsedimgURL = img.replacingOccurrences(of: "_md", with: "").replacingOccurrences(of: "images/abilities", with: "images/dota_react/abilities")
            WebImage(url: URL(string: "https://cdn.cloudflare.steamstatic.com\(parsedimgURL)"))
                .resizable()
                .renderingMode(.original)
                .indicator(.activity)
                .transition(.fade)
                .aspectRatio(contentMode: .fit)
        }
    }
    @ViewBuilder private func buildTalent(talent: [Talent]) -> some View {
        VStack {
            HStack {
                Text("Talents")
                    .font(.custom(fontString, size: 15))
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
                let talents = talent.filter { talent in return talent.level == level }
                Text(LocalizedStringKey(talents.first!.name))
                    .font(.custom(fontString, size: 10))
                    .frame(width: (proxy.size.width - 40) / 2)
                Text("\(5 + 5 * level)")
                    .font(.custom(fontString, size: 10))
                    .bold()
                    .padding(5)
                    .frame(width: 30, height: 30)
                    .background(Circle().stroke().foregroundColor(.yellow))
                Text(LocalizedStringKey(talents.last!.name))
                    .font(.custom(fontString, size: 10))
                    .frame(width: (proxy.size.width - 30) / 2)
            }
        }
        .frame(height: 30)
        .padding(.horizontal)
    }
    
    @ViewBuilder private func buildHeroDetail() -> some View {
        buildAttributes(hero: vm.hero)
        Divider()
        buildStats(hero: vm.hero)
        Divider()
        buildTalent(talent: vm.heroAbility.talents)
    }
    
    @ViewBuilder private func buildStats(hero: Hero) -> some View {
        VStack {
            HStack {
                Text("Stats")
                    .font(.custom(fontString, size: 15))
                    .bold()
                Spacer()
            }.padding(.leading)
            HStack(alignment: .top) {
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Attack")
                        .font(.custom(fontString, size: 15))
                    buildStatDetail(image: "icon_damage", value: "\(hero.calculatedAttackMin)-\(hero.calculatedAttackMax)")
                    buildStatDetail(image: "icon_attack_time", value: "\(hero.attackRate)")
                    buildStatDetail(image: "icon_attack_range", value: "\(hero.attackRange)")
                    buildStatDetail(image: "icon_projectile_speed", value: "\(hero.projectileSpeed)")
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Defense")
                        .font(.custom(fontString, size: 15))
                    buildStatDetail(image: "icon_armor", value: String(format: "%.1f", hero.calculateArmor))
                    buildStatDetail(image: "icon_magic_resist", value: "\(hero.baseMr)%")
                }
                Spacer()
                VStack(alignment: .leading, spacing: 5) {
                    Text("Mobility")
                        .font(.custom(fontString, size: 15))
                    buildStatDetail(image: "icon_movement_speed", value: "\(hero.moveSpeed)")
                    buildStatDetail(image: "icon_turn_rate", value: "\(hero.turnRate ?? 0.6)")
                    buildStatDetail(image: "icon_vision", value: "\(hero.id == 42 ? "800/1800" : "1800/800")")
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
                .font(.custom(fontString, size: 15))
        }
    }
    
    @ViewBuilder private func buildAttributes(hero: Hero) -> some View {
        VStack {
            HStack {
                Text("Attributes")
                    .font(.custom(fontString, size: 15))
                    .bold()
                Spacer()
            }.padding(.bottom)
            //            Slider(value: $heroLevel, in: 1...30, step: 1)
            //                .padding(.horizontal)
            //            Text("Level \(Int(heroLevel))")
            
            VStack(spacing: 0) {
                HStack {
                    Text("Health")
                        .font(.custom(fontString, size: 15))
                        .bold()
                        .foregroundColor(.secondaryLabel)
                    Spacer()
                    Text("\(hero.calculateHPLevel(level: heroLevel))")
                        .font(.custom(fontString, size: 15))
                        .bold()
                    Text("+ \(hero.calculateHPRegen, specifier: "%.1f")")
                        .font(.custom(fontString, size: 13))
                }
                buildManaHealthBar(total: hero.calculateHPLevel(level: heroLevel), color: Color(UIColor.systemGreen))
            }
            VStack(spacing: 0) {
                HStack {
                    Text("Mana")
                        .font(.custom(fontString, size: 15))
                        .bold()
                        .foregroundColor(.secondaryLabel)
                    Spacer()
                    Text("\(hero.calculateManaLevel(level: heroLevel))")
                        .font(.custom(fontString, size: 15))
                        .bold()
                    Text("+ \(hero.calculateMPRegen, specifier: "%.1f")")
                        .font(.custom(fontString, size: 13))
                }
                
                buildManaHealthBar(total: hero.calculateManaLevel(level: heroLevel), color: Color(UIColor.systemBlue))
            }
            
            
            HStack {
                Spacer()
                HStack {
                    Image("hero_str")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("\(hero.baseStr)")
                        .font(.custom(fontString, size: 18))
                        .bold()
                    Text("+ \(hero.strGain, specifier: "%.1f")")
                        .font(.custom(fontString, size: 13))
                }
                Spacer()
                HStack {
                    Image("hero_agi")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("\(hero.baseAgi)")
                        .font(.custom(fontString, size: 18))
                        .bold()
                    Text("+ \(hero.agiGain, specifier: "%.1f")")
                        .font(.custom(fontString, size: 13))
                }
                Spacer()
                HStack {
                    Image("hero_int")
                        .resizable()
                        .frame(width: 15, height: 15)
                    Text("\(hero.baseInt)")
                        .font(.custom(fontString, size: 18))
                        .bold()
                    Text("+ \(hero.intGain, specifier: "%.1f")")
                        .font(.custom(fontString, size: 13))
                }
                Spacer()
            }
        }
        .padding(.horizontal)
    }
    
    @ViewBuilder private func buildManaHealthBar(total: Int, color: Color) -> some View {
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
        NavigationView {
            HeroDetailView(vm: HeroDetailViewModel.preview)
        }
    }
}

struct AbilityView: View {
    @EnvironmentObject var dataBase: HeroDatabase
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: AbilityViewModel
    
    init(ability: Ability, heroID: Int, abilityName: String) {
        self.vm = AbilityViewModel(ability: ability, heroID: heroID, abilityName: abilityName)
    }
    
    var body: some View {
        VStack {
            ScrollView(.vertical, showsIndicators: false) {
                HStack(alignment: .top, spacing: 10) {
                    let parsedimgURL = vm.ability.img!.replacingOccurrences(of: "_md", with: "").replacingOccurrences(of: "images/abilities", with: "images/dota_react/abilities")
                    WebImage(url: URL(string: "https://cdn.cloudflare.steamstatic.com\(parsedimgURL)"))
                        .resizable()
                        .renderingMode(.original)
                        .indicator(.activity)
                        .transition(.fade)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    VStack(alignment: .leading) {
                        Text(vm.ability.dname ?? "")
                            .font(.custom(fontString, size: 18))
                            .bold()
                        if let cd = vm.ability.coolDown {
                            Text("Cooldown: \(cd.transformString())")
                                .font(.custom(fontString, size: 14)).foregroundColor(Color(UIColor.secondaryLabel))
                        }
                        if let mc = vm.ability.manaCost {
                            Text("Cost: \(mc.transformString())")
                                .font(.custom(fontString, size: 14)).foregroundColor(Color(UIColor.secondaryLabel))
                        }
                    }
                    Spacer()
                }
                
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 100, maximum: 200), spacing: 5), count: 2),alignment: .leading, spacing: 5) {
                    if let behavior = vm.ability.behavior {
                        buildAttributesText(title: "ABILITY:", message: "\(behavior.transformString())")
                    }
                    if let targetTeam = vm.ability.targetTeam {
                        buildAttributesText(title: "PIERCES SPELL:", message: "\(targetTeam.transformString())")
                    }
                    if let targetType = vm.ability.targetType {
                        buildAttributesText(title: "AFFECTS:", message: "\(targetType.transformString())")
                    }
                    if let bkbPierce = vm.ability.bkbPierce {
                        buildAttributesText(title: "IMMUNITY:", message: "\(bkbPierce.transformString())", color: bkbPierce.transformString() == "Yes" ? Color.green : Color(uiColor: UIColor.label))
                    }
                    if let dispellable = vm.ability.dispellable {
                        let dispellableString = dispellable.transformString()
                        if dispellableString == "" {
                            buildAttributesText(title: "DISPELLABLE:", message: "Only Strong Dispels", color: .red)
                        } else {
                            buildAttributesText(title: "DISPELLABLE:", message: "\(dispellable.transformString())", color: dispellable.transformString() == "No" ? .red : Color(uiColor: UIColor.label))
                        }
                    }
                    if let damageType = vm.ability.damageType {
                        buildAttributesText(title: "DAMAGE TYPE:", message: "\(damageType.transformString())", color: {
                            if damageType.transformString() == "Magical" {
                                return Color.blue
                            } else if damageType.transformString() == "Physics" {
                                return Color.red
                            } else if damageType.transformString() == "Pure" {
                                return Color.yellow
                            } else {
                                return Color(UIColor.label)
                            }
                        }())
                    }
                }
                Group {
                    VStack {
                        if dataBase.isScepterSkill(ability: vm.ability, heroID: vm.heroID) {
                            buildDescription(desc: vm.ability.desc ?? "", type: .Scepter)
                        } else if dataBase.isShardSkill(ability: vm.ability, heroID: vm.heroID) {
                            buildDescription(desc: vm.ability.desc ?? "", type: .Shard)
                        } else {
                            buildDescription(desc: vm.ability.desc ?? "")
                            if let scepterDesc = dataBase.getAbilityScepterDesc(ability: vm.ability, heroID: vm.heroID) {
                                buildDescription(desc: scepterDesc, type: .Scepter)
                            }
                            if let shardDesc = dataBase.getAbilityShardDesc(ability: vm.ability, heroID: vm.heroID) {
                                buildDescription(desc: shardDesc, type: .Shard)
                            }
                        }
                    }
                }
                Spacer().frame(height: 10)
                if let attributes = vm.ability.attributes {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            ForEach(attributes, id: \.self) { item in
                                buildAttributesText(title: item.header ?? "", message: item.value?.transformString() ?? "")
                            }
                        }
                        Spacer()
                    }
                }
                Spacer().frame(height: 10)
                //https://cdn.cloudflare.steamstatic.com/apps/dota2/videos/dota_react/abilities/keeper_of_the_light/keeper_of_the_light_aghanims_shard.mp4
                
                if let lore = vm.ability.lore {
                    Text(lore)
                        .font(.custom(fontString, size: 10))
                        .padding(8)
                        .foregroundColor(Color(UIColor.tertiaryLabel))
                        .background(
                            RoundedRectangle(cornerRadius: 5)
                                .foregroundColor(Color(UIColor.tertiarySystemBackground))
                        )
                }
                
            }
            
        }
        
        .padding(.horizontal)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button {
                self.presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
            }
        }
    }
    
    @ViewBuilder private func buildAttributesText(title: String, message: String, color: Color = Color(UIColor.label)) -> some View {
        HStack {
            Text(title)
                .font(.custom(fontString, size: 11))
                .foregroundColor(Color(uiColor: UIColor.secondaryLabel))
                .lineLimit(1)
            Text(message)
                .font(.custom(fontString, size: 11))
                .bold()
                .lineLimit(1)
                .foregroundColor(color)
        }
    }

    @ViewBuilder private func buildDescription(desc: String, type: ScepterType = .non) -> some View {
        VStack(alignment: .leading) {
            if type != .non {
                HStack {
                    Image("\(type.rawValue.lowercased())_1")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 18)
                    Text("\(type.rawValue) Upgrade")
                        .font(.custom(fontString, size: 15))
                        .bold()
                    Spacer()
                }
            }
            Text(desc)
                .font(.custom(fontString, size: 13))
            switch type {
            case .Scepter:
                if let url = vm.scepterVideo {
                    VideoPlayer(player: AVPlayer(url: url))
                        .frame(height: (UIScreen.main.bounds.width - 32) / 16.0 * 9.0)
                }
            case .Shard:
                if let url = vm.shardVideo {
                    VideoPlayer(player: AVPlayer(url: url))
                        .frame(height: (UIScreen.main.bounds.width - 32) / 16.0 * 9.0)
                }
            case .non:
                if let url = vm.abilityVideo {
                    VideoPlayer(player: AVPlayer(url: url))
                        .frame(height: (UIScreen.main.bounds.width - 32) / 16.0 * 9.0)
                }
            }
            
        }
        .padding(calculateDescPadding(type: type))
        .background(calculateDescBackground(type: type))
    }
    
    private func calculateDescPadding(type: ScepterType) -> CGFloat {
        switch type {
        case .Scepter:
            return 10
        case .Shard:
            return 10
        case .non:
            return 0
        }
    }
    
    @ViewBuilder private func calculateDescBackground(type: ScepterType) -> some View {
        switch type {
        case .Scepter:
            RoundedRectangle(cornerRadius: 3)
                .foregroundColor(Color(UIColor.secondarySystemBackground))
        case .Shard:
            RoundedRectangle(cornerRadius: 3)
                .foregroundColor(Color(UIColor.secondarySystemBackground))
        case .non:
            EmptyView()
        }
    }
}

enum ScepterType: String {
    case Scepter
    case Shard
    case non
}



