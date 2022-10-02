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
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: AbilityViewModel

    var body: some View {
        if let openDotaAbility = vm.opentDotaAbility,
           let stratzAbility = vm.stratzAbility {
            GeometryReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    buildTitle(openDotaAbility: openDotaAbility,
                               stratzAbility: stratzAbility)
                    buildStats(ability: openDotaAbility)
                    buildDescription(ability: openDotaAbility,
                                     stratz: stratzAbility,
                                     proxy: proxy)
                    Spacer().frame(height: 10)
                    if let attributes = stratzAbility.language?.attributes?.compactMap({$0}) {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                ForEach(attributes, id: \.self) { item in
                                    let splits = item.split(separator: colonLocalize)
                                    if splits.count == 2 {
                                        let header = String(splits.first ?? "")
                                        let message = String(splits.last ?? "")
                                        self.buildAttributesText(title: "\(header):", message: message)
                                    } else {
                                        self.buildAttributesText(title: item, message: "")
                                    }
                                }
                            }
                            Spacer()
                        }
                    }
                    Spacer().frame(height: 10)
                    if let lore = stratzAbility.language?.lore {
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
//                    self.presentationMode.wrappedValue.dismiss()
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                }
            }
        } else {
            ProgressView()
        }
    }
    
    @ViewBuilder private func buildTitle(openDotaAbility: Ability, stratzAbility: AbilityQuery.Data.Constant.Ability) -> some View {
        HStack(alignment: .top, spacing: 10) {
            let parsedimgURL = openDotaAbility.img!.replacingOccurrences(of: "_md", with: "").replacingOccurrences(of: "images/abilities", with: "images/dota_react/abilities")
            AbilityImage(url: "https://cdn.cloudflare.steamstatic.com\(parsedimgURL)", sideLength: 70, cornerRadius: 20)
            VStack(alignment: .leading) {
                Text(stratzAbility.language?.displayName ?? "")
                    .font(.custom(fontString, size: 18))
                    .bold()
                if let cd = openDotaAbility.coolDown {
                    Text("Cooldown: \(cd.transformString())")
                        .font(.custom(fontString, size: 14)).foregroundColor(Color(UIColor.secondaryLabel))
                }
                if let mc = openDotaAbility.manaCost {
                    Text("Cost: \(mc.transformString())")
                        .font(.custom(fontString, size: 14)).foregroundColor(Color(UIColor.secondaryLabel))
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder private func buildStats(ability: Ability) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 100, maximum: 200), spacing: 5), count: 2),alignment: .leading, spacing: 5) {
            if let behavior = ability.behavior {
                buildAttributesText(title: "ABILITY:", message: "\(behavior.transformString())")
            }
            if let targetTeam = ability.targetTeam {
                buildAttributesText(title: "PIERCES SPELL:", message: "\(targetTeam.transformString())")
            }
            if let targetType = ability.targetType {
                buildAttributesText(title: "AFFECTS:", message: "\(targetType.transformString())")
            }
            if let bkbPierce = ability.bkbPierce {
                buildAttributesText(title: "IMMUNITY:", message: "\(bkbPierce.transformString())", color: bkbPierce.transformString() == "Yes" ? Color.green : Color(uiColor: UIColor.label))
            }
            if let dispellable = ability.dispellable {
                let dispellableString = dispellable.transformString()
                if dispellableString == "" {
                    buildAttributesText(title: "DISPELLABLE:", message: "Only Strong Dispels", color: .red)
                } else {
                    buildAttributesText(title: "DISPELLABLE:", message: "\(dispellable.transformString())", color: dispellable.transformString() == "No" ? .red : Color(uiColor: UIColor.label))
                }
            }
            if let damageType = ability.damageType {
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
    }
    
    @ViewBuilder private func buildDescription(ability: Ability,
                                               stratz: AbilityQuery.Data.Constant.Ability,
                                               proxy: GeometryProxy) -> some View {
        VStack {
            let description = stratz.language?.description?.compactMap{ $0 }.joined(separator: "\n") ?? ""
            if dataBase.isScepterSkill(ability: ability, heroID: vm.heroID) {
                buildDescription(desc: description, type: .Scepter, width: proxy.size.width)
            } else if dataBase.isShardSkill(ability: ability, heroID: vm.heroID) {
                buildDescription(desc: description, type: .Shard, width: proxy.size.width)
            } else {
                buildDescription(desc: description, width: proxy.size.width)
                if let scepterDesc = stratz.language?.aghanimDescription {
                    buildDescription(desc: scepterDesc, type: .Scepter, width: proxy.size.width)
                }
                if let shardDesc = stratz.language?.shardDescription {
                    buildDescription(desc: shardDesc, type: .Shard, width: proxy.size.width)
                }
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
                        buildPlayer(player: vm.getPlayer(url: url), width: width)
                    }
                case .Shard:
                    if let url = vm.shardVideo {
                        buildPlayer(player: vm.getPlayer(url: url), width: width)
                    }
                case .non:
                    if let url = vm.abilityVideo {
                        buildPlayer(player: vm.getPlayer(url: url), width: width)
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
    
    @ViewBuilder private func buildPlayer(player: AVPlayer, width: CGFloat) -> some View {
        VideoPlayer(player: player)
            .frame(width: width - 40, height: (width - 40.0) / 16.0 * 9.0)
            .disabled(true)
            .onAppear {
                player.play()
                self.vm.addObserver(player: player)
            }
            .onDisappear {
                player.pause()
                self.vm.removeObserver(player: player)
            }
    }
}
