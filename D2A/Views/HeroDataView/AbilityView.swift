//
//  AbilityView.swift
//  App
//
//  Created by Shibo Tong on 26/8/2022.
//

import SwiftUI
import AVKit
import StratzAPI

enum ScepterType: String {
    case scepter
    case shard
    case non
    
    var upgradeString: LocalizedStringKey {
        switch self {
        case .scepter:
            return LocalizedStringKey("SCEPTER UPGRADE")
        case .shard:
            return LocalizedStringKey("SHARD UPGRADE")
        case .non:
            return LocalizedStringKey("")
        }
    }
}

struct AbilityView: View {
    @EnvironmentObject var dataBase: HeroDatabase
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: AbilityViewModel

    var body: some View {
        if let openDotaAbility = viewModel.opentDotaAbility,
           let stratzAbility = viewModel.stratzAbility {
            GeometryReader { proxy in
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
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
                                            buildAttributesText(title: "\(header):", message: message)
                                        } else {
                                            buildAttributesText(title: item, message: "")
                                        }
                                    }
                                }
                                Spacer()
                            }
                        }
                        Spacer().frame(height: 10)
                        if let lore = stratzAbility.language?.lore {
                            Text(lore)
                                .font(.system(size: 10))
                                .padding(8)
                                .foregroundColor(Color(UIColor.tertiaryLabel))
                                .background(
                                    RoundedRectangle(cornerRadius: 5)
                                        .foregroundColor(Color(UIColor.tertiarySystemBackground))
                                )
                        }
                    }
                    .padding(.vertical)
                }
            }
            .padding(.horizontal)
            .navigationBarTitleDisplayMode(.inline)
        } else {
            ProgressView()
        }
    }
    
    @ViewBuilder private func buildTitle(openDotaAbility: Ability, stratzAbility: AbilityQuery.Data.Constants.Ability) -> some View {
        HStack(alignment: .top, spacing: 10) {
            let parsedimgURL = openDotaAbility.img!.replacingOccurrences(of: "_md", with: "").replacingOccurrences(of: "images/abilities", with: "images/dota_react/abilities")
            AbilityImage(viewModel: AbilityImageViewModel(name: openDotaAbility.name ?? "", urlString: "https://cdn.cloudflare.steamstatic.com\(parsedimgURL)", sideLength: 70, cornerRadius: 20))
            VStack(alignment: .leading) {
                Text(stratzAbility.language?.displayName ?? "")
                    .font(.system(size: 18))
                    .bold()
                if let cd = openDotaAbility.coolDown?.transformString() {
                    Text("Cooldown: \(cd)")
                        .font(.system(size: 14)).foregroundColor(Color(UIColor.secondaryLabel))
                }
                if let mc = openDotaAbility.manaCost?.transformString() {
                    Text("Cost: \(mc)")
                        .font(.system(size: 14)).foregroundColor(Color(UIColor.secondaryLabel))
                }
            }
            Spacer()
        }
    }
    
    @ViewBuilder private func buildStats(ability: Ability) -> some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(minimum: 100, maximum: 200), spacing: 5), count: 2), alignment: .leading, spacing: 5) {
            if let behavior = ability.behavior?.transformString() {
                buildAttributesText(title: "ABILITY:", message: "\(behavior)")
            }
            if let targetTeam = ability.targetTeam?.transformString() {
                switch targetTeam {
                case "Both":
                    buildAttributesText(title: "AFFECTS:", message: "Heroes")
                case "Enemy":
                    buildAttributesText(title: "AFFECTS:", message: "Enemy Units")
                case "Friendly":
                    buildAttributesText(title: "AFFECTS:", message: "Allied Units")
                default:
                    EmptyView()
                }
            }
            if let bkbPierce = ability.bkbPierce?.transformString() {
                buildAttributesText(title: "IMMUNITY:", message: "\(bkbPierce)", color: bkbPierce == "Yes" ? Color.green : Color(uiColor: UIColor.label))
            }
            if let dispellable = ability.dispellable {
                if let dispellableString = dispellable.transformString() {
                    buildAttributesText(title: "DISPELLABLE:",
                                        message: "\(dispellableString)",
                                        color: dispellableString == "No" ? .red : Color(uiColor: UIColor.label))
                } else {
                    buildAttributesText(title: "DISPELLABLE:", message: "Only Strong Dispels", color: .red)
                }
            }
            if let damageType = ability.damageType?.transformString() {
                buildAttributesText(title: "DAMAGE TYPE:", message: "\(damageType)", color: {
                    if damageType == "Magical" {
                        return Color.blue
                    } else if damageType == "Physical" {
                        return Color.red
                    } else if damageType == "Pure" {
                        return Color.yellow
                    } else {
                        return Color(UIColor.label)
                    }
                }())
            }
        }
    }
    
    @ViewBuilder private func buildDescription(ability: Ability,
                                               stratz: AbilityQuery.Data.Constants.Ability,
                                               proxy: GeometryProxy) -> some View {
        VStack {
            let description = stratz.language?.description?.compactMap { $0 }.joined(separator: "\n") ?? ""
            if dataBase.isScepterSkill(ability: ability, heroID: viewModel.heroID) {
                buildDescription(desc: description, type: .scepter, width: proxy.size.width)
            } else if dataBase.isShardSkill(ability: ability, heroID: viewModel.heroID) {
                buildDescription(desc: description, type: .shard, width: proxy.size.width)
            } else {
                buildDescription(desc: description, width: proxy.size.width)
                if let scepterDesc = stratz.language?.aghanimDescription {
                    buildDescription(desc: scepterDesc, type: .scepter, width: proxy.size.width)
                }
                if let shardDesc = stratz.language?.shardDescription {
                    buildDescription(desc: shardDesc, type: .shard, width: proxy.size.width)
                }
            }
        }
    }

    @ViewBuilder private func buildAttributesText(title: String, message: String, color: Color = Color(UIColor.label)) -> some View {
        HStack {
            Text(LocalizedStringKey(title))
                .font(.system(size: 11))
                .foregroundColor(Color(uiColor: UIColor.secondaryLabel))
                .lineLimit(1)
            Text(LocalizedStringKey(message))
                .font(.system(size: 11))
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
                    Text(type.upgradeString)
                        .font(.system(size: 15))
                        .bold()
                    Spacer()
                }
            }
            Text(desc)
                .font(.system(size: 13))
            HStack {
                Spacer()
                switch type {
                case .scepter:
                    if let video = viewModel.scepterVideo {
                        buildPlayer(player: video, width: width)
                    }
                case .shard:
                    if let video = viewModel.shardVideo {
                        buildPlayer(player: video, width: width)
                    }
                case .non:
                    if let video = viewModel.abilityVideo {
                        buildPlayer(player: video, width: width)
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
        case .scepter:
            return 10
        case .shard:
            return 10
        case .non:
            return 0
        }
    }

    @ViewBuilder private func calculateDescBackground(type: ScepterType) -> some View {
        switch type {
        case .scepter:
            RoundedRectangle(cornerRadius: 3)
                .foregroundColor(Color(UIColor.secondarySystemBackground))
        case .shard:
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
                player.seek(to: .zero)
                player.play()
                NotificationCenter.default.addObserver(
                    forName: .AVPlayerItemDidPlayToEndTime,
                    object: player.currentItem,
                    queue: nil) { _ in
                        player.seek(to: .zero)
                        player.play()
                    }
            }
            .onDisappear {
                player.pause()
                NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
            }
    }
}
