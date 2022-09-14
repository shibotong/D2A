//
//  AbilityView.swift
//  App
//
//  Created by Shibo Tong on 26/8/2022.
//

import SwiftUI
import AVKit

enum ScepterType: String {
    case Scepter
    case Shard
    case non
}

struct AbilityView: View {
    @EnvironmentObject var dataBase: HeroDatabase
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: AbilityViewModel

    init(ability: Ability, heroID: Int, abilityName: String) {
        self.vm = AbilityViewModel(ability: ability, heroID: heroID, abilityName: abilityName)
    }

    var body: some View {
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                HStack(alignment: .top, spacing: 10) {
                    let parsedimgURL = vm.ability.img!.replacingOccurrences(of: "_md", with: "").replacingOccurrences(of: "images/abilities", with: "images/dota_react/abilities")
                    AbilityImage(url: "https://cdn.cloudflare.steamstatic.com\(parsedimgURL)", sideLength: 70, cornerRadius: 20)
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
                            if let scepterDesc = dataBase.getAbilityScepterDesc(ability: vm.ability, heroID: vm.heroID) {
                                buildDescription(desc: scepterDesc, type: .Scepter, width: proxy.size.width)
                            }
                        } else if dataBase.isShardSkill(ability: vm.ability, heroID: vm.heroID) {
                            if let shardDesc = dataBase.getAbilityShardDesc(ability: vm.ability, heroID: vm.heroID) {
                                buildDescription(desc: shardDesc, type: .Shard, width: proxy.size.width)
                            }
                        } else {
                            buildDescription(desc: vm.ability.desc ?? "", width: proxy.size.width)
                            if let scepterDesc = dataBase.getAbilityScepterDesc(ability: vm.ability, heroID: vm.heroID) {
                                buildDescription(desc: scepterDesc, type: .Scepter, width: proxy.size.width)
                            }
                            if let shardDesc = dataBase.getAbilityShardDesc(ability: vm.ability, heroID: vm.heroID) {
                                buildDescription(desc: shardDesc, type: .Shard, width: proxy.size.width)
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

    @ViewBuilder private func buildDescription(desc: String, type: ScepterType = .non, width: CGFloat) -> some View {
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
            HStack {
                Spacer()
                switch type {
                case .Scepter:
                    if let url = vm.scepterVideo {
                        VideoPlayer(player: AVPlayer(url: url))
                            .frame(width: width - 40, height: (width - 40.0) / 16.0 * 9.0)
                    }
                case .Shard:
                    if let url = vm.shardVideo {
                        VideoPlayer(player: AVPlayer(url: url))
                            .frame(width: width - 40, height: (width - 40.0) / 16.0 * 9.0)
                    }
                case .non:
                    if let url = vm.abilityVideo {
                        VideoPlayer(player: AVPlayer(url: url))
                            .frame(width: width - 20, height: (width - 20.0) / 16.0 * 9.0)
                    }
                }
                Spacer()
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
