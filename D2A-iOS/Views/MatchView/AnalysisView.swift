//
//  AnalysisView.swift
//  App
//
//  Created by Shibo Tong on 16/8/21.
//

import Combine
import SwiftUI

struct AnalysisView: View {
    @ObservedObject var viewModel: AnalysisViewModel

    private let selections: [AnalysisType]

    init(players: [PlayerRowViewModel], selections: [AnalysisType] = [.heroDamage, .golds, .kills]) {
        self.viewModel = AnalysisViewModel(player: players)
        self.selections = selections
    }

    var body: some View {
        VStack {
            HStack {
                Text("Analysis").font(.system(size: 20)).bold()
                Spacer()
                HStack {
                    Menu {
                        Picker("picker", selection: $viewModel.selection) {
                            ForEach(selections) { selection in
                                Text(selection.rawValue).tag(selection)
                            }
                        }
                    } label: {
                        Label(viewModel.selection.rawValue, systemImage: "chevron.down")
                    }
                }.font(.system(size: 15)).foregroundColor(Color(.secondaryLabel))
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 10).foregroundColor(
                            Color(.secondarySystemBackground)))
            }
            VStack(spacing: 0) {
                ForEach(viewModel.players, id: \.slot) { player in
                    PlayerAnalysisRowView(
                        player: player, value: viewModel.fetchPlayerValueString(player: player),
                        percentage: viewModel.calculatePercentage(player: player))
                }
            }
        }.padding(20)
    }
}

enum AnalysisType: LocalizedStringKey, Identifiable {

    var id: AnalysisType {
        return self
    }

    case kills = "KDA"
    case level = "Level"
    case xpm = "XPM"
    case gpm = "GPM"
    case golds = "Net Worth"
    case heroDamage = "Hero Damage"
    case lastHitsDenies = "LH/DN"

    var localized: String {
        switch self {
        case .kills:
            return LocalizableStrings.kills
        case .level:
            return LocalizableStrings.gold
        case .xpm:
            return LocalizableStrings.heroDamage
        case .gpm:
            return LocalizableStrings.towerDamage
        case .golds:
            return ""
        case .heroDamage:
            return ""
        case .lastHitsDenies:
            return ""
        }
    }
}

struct PlayerAnalysisRowView: View {
    var player: PlayerRowViewModel
    var value: String
    var percentage: Double

    var body: some View {
        HStack {
            HeroImageView(heroID: Int(player.heroID), type: .icon).frame(width: 35, height: 35)
            VStack(alignment: .leading, spacing: 0) {
                ProgressView(value, value: percentage > 1 ? 1 : percentage, total: 1)
                    .accentColor(Color(player.slot <= 127 ? .systemGreen : .systemRed).opacity(0.8))
                    .progressViewStyle(LinearProgressViewStyle())

            }
        }.frame(height: 50)
    }
}

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView(players: [.init(heroID: 2), .init(heroID: 1), .init(heroID: 3)])
    }
}
