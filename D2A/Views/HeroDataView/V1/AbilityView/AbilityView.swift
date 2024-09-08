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
        GeometryReader { proxy in
            ScrollView(.vertical, showsIndicators: false) {
                VStack {
                    AbilityTitleView(displayName: viewModel.displayName,
                                     cd: viewModel.cd,
                                     mc: viewModel.mc,
                                     name: viewModel.abilityID,
                                     url: viewModel.abilityImageURL)
                    AbilityStatsView(behavior: viewModel.behavior,
                                     targetTeam: viewModel.targetTeam,
                                     bkbPierce: viewModel.bkbPierce, 
                                     dispellable: viewModel.dispellable,
                                     damageType: viewModel.damageType)
//                    if let openDota = viewModel.opentDotaAbility,
//                       let stratz = $viewModel.stratzAbility {
//                        buildDescription(ability: openDota,
//                                         stratz: stratz,
//                                         proxy: proxy)
//                    }
                    
                    Spacer().frame(height: 10)
                    if let attributes = viewModel.stratzAbility?.localizedAttributes {
                        HStack {
                            VStack(alignment: .leading, spacing: 5) {
                                ForEach(attributes, id: \.self) { item in
                                    AbilityStatsTextView(title: item.name, message: item.description)
                                }
                            }
                            Spacer()
                        }
                    }
                    Spacer().frame(height: 10)
                    if let lore = viewModel.stratzAbility?.language?.lore {
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
    }
    
    @ViewBuilder private func buildDescription(ability: AbilityCodable,
                                               stratz: LocaliseQuery.Data.Constants.Ability,
                                               proxy: GeometryProxy) -> some View {
        VStack {
            let description = stratz.language?.description?.compactMap { $0 }.joined(separator: "\n") ?? ""
            if dataBase.isScepterSkill(ability: ability, heroID: viewModel.heroID) {
                AbilityDescriptionView(width: proxy.size.width, type: .scepter, description: description, player: viewModel.scepterVideo)
            } else if dataBase.isShardSkill(ability: ability, heroID: viewModel.heroID) {
                AbilityDescriptionView(width: proxy.size.width, type: .shard, description: description, player: viewModel.shardVideo)
            } else {
                AbilityDescriptionView(width: proxy.size.width, type: .non, description: description, player: viewModel.abilityVideo)
                if let scepterDesc = stratz.language?.aghanimDescription {
                    AbilityDescriptionView(width: proxy.size.width, type: .scepter, description: scepterDesc, player: viewModel.scepterVideo)
                }
                if let shardDesc = stratz.language?.shardDescription {
                    AbilityDescriptionView(width: proxy.size.width, type: .shard, description: shardDesc, player: viewModel.shardVideo)
                }
            }
        }
    }
}

struct AbilityView_Previews: PreviewProvider {
    static let ability = HeroDatabase.preview.fetchOpenDotaAbility(name: "antimage_name_break")
    static var previews: some View {
        Group {
            NavigationView {
                AbilityView(viewModel: AbilityViewModel(heroID: 1, ability: ability))
                    .environmentObject(HeroDatabase.preview)
            }
            .previewDevice(.iPhone)
        }
    }
}
