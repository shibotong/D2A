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
                    if let openDota = viewModel.opentDotaAbility {
                        buildDescription(proxy: proxy)
                    }
                    
                    Spacer().frame(height: 10)
                    if let attributes = viewModel.attributes {
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
                    if let lore = viewModel.lore {
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
    
    @ViewBuilder
    private func buildDescription(proxy: GeometryProxy) -> some View {
        VStack {
            if let description = viewModel.description {
                AbilityDescriptionView(width: proxy.size.width, type: .non, description: description, player: viewModel.abilityVideo)
            }
            if let scepter = viewModel.scepter {
                AbilityDescriptionView(width: proxy.size.width, type: .scepter, description: scepter, player: viewModel.scepterVideo)
            }
            if let shard = viewModel.shard {
                AbilityDescriptionView(width: proxy.size.width, type: .shard, description: shard, player: viewModel.shardVideo)
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
