//
//  AnalysisView.swift
//  App
//
//  Created by Shibo Tong on 16/8/21.
//

import SwiftUI
import Combine

struct AnalysisView: View {
    @ObservedObject var vm: AnalysisViewModel
    var body: some View {
        VStack {
            HStack {
                Text("Analysis").font(.system(size: 20)).bold()
                Spacer()
                HStack {
                    Menu {
                        Picker("picker", selection: $vm.selection) {
                            Text("Tower Damage").tag(AnalysisType.towerDamage)
                            Text("Hero Damage").tag(AnalysisType.heroDamage)
                            Text("Net Worth").tag(AnalysisType.golds)
                            Text("Kills").tag(AnalysisType.kills)
                        }
                    } label: {
                        Label(vm.selection.rawValue, systemImage: "chevron.down")
                    }
                }.font(.system(size: 15)).foregroundColor(Color(.secondaryLabel))
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.secondarySystemBackground)))
            }
            if vm.players == nil {
                Text("\(vm.selection.localized) is not available").font(.system(size: 15)).frame(height: 300).foregroundColor(Color(.tertiaryLabel))
            } else {
//                GeometryReader { proxy in
//                    if proxy.size.width > 400 {
//                        HStack {
//                            VStack {
//                                ForEach(vm.players!.filter {$0.slot < 128}, id:\.heroID) { player in
//                                    PlayerAnalysisRowView(player: player, value: vm.fetchPlayerValue(player: player), percentage: vm.calculatePercentage(player: player))
//                                }
//                            }
//                            VStack {
//                                ForEach(vm.players!.filter {$0.slot >= 128}, id:\.heroID) { player in
//                                    PlayerAnalysisRowView(player: player, value: vm.fetchPlayerValue(player: player), percentage: vm.calculatePercentage(player: player))
//                                }
//                            }
//                        }
//                    } else {
                        VStack(spacing: 0) {
                            ForEach(vm.players!, id: \.heroID) { player in
                                PlayerAnalysisRowView(player: player, value: vm.fetchPlayerValue(player: player), percentage: vm.calculatePercentage(player: player))
                            }
                        }
//                    }
//                }.frame(height: 500)
            }
        }.padding(20)
    }
}

// struct AnalysisView_Preview: PreviewProvider {
//    static var previews: some View {
//        AnalysisView(vm: AnalysisViewModel(player: []))
//            .environment(\.locale, .init(identifier: "zh-Hans"))
//    }
// }

enum AnalysisType: LocalizedStringKey {
    case kills = "Kills"
    case golds = "Net Worth"
    case heroDamage = "Hero Damage"
    case towerDamage = "Tower Damage"
    
    var localized: String {
        switch self {
        case .kills:
            return LocalizableStrings.kills
        case .golds:
            return LocalizableStrings.gold
        case .heroDamage:
            return LocalizableStrings.heroDamage
        case .towerDamage:
            return LocalizableStrings.towerDamage
        }
    }
    
}

struct PlayerAnalysisRowView: View {
    var player: Player
    var value: Int
    var percentage: Double
    
    var body: some View {
        HStack {
            HeroImageView(heroID: Int(player.heroID), type: .icon).frame(width: 35, height: 35)
            VStack(alignment: .leading, spacing: 0) {
                ProgressView("\(Int(value))", value: percentage > 1 ? 1 : percentage, total: 1)
                    .accentColor(Color(player.slot <= 127 ? .systemGreen : .systemRed).opacity(0.8))
                    .progressViewStyle(LinearProgressViewStyle())
                    
            }
        }.frame(height: 50)
    }
}
