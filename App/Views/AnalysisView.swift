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
                Text("Analysis").font(.custom(fontString, size: 20)).bold()
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
                        Label("\(vm.selection.rawValue)", systemImage: "chevron.down")
                    }
                }.font(.custom(fontString, size: 15)).foregroundColor(Color(.secondaryLabel))
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.secondarySystemBackground)))
            }
            if vm.players == nil {
                Text("\(vm.selection.rawValue) is not available").font(.custom(fontString, size: 15)).frame(height: 300).foregroundColor(Color(.tertiaryLabel))
            } else {
                ForEach(vm.players!, id:\.heroID) { player in
                    PlayerAnalysisRowView(player: player, value: vm.fetchPlayerValue(player: player), percentage: vm.calculatePercentage(player: player))
                }
            }
        }.padding(20)
    }
}

enum AnalysisType: String {
    case kills = "Kills"
    case golds = "Net Worth"
    case heroDamage = "Hero Damage"
    case towerDamage = "Tower Damage"
    
}

struct PlayerAnalysisRowView: View {
    var player: Player
    var value: Int
    var percentage: Double
    
    var body: some View {
        HStack {
            HeroIconImageView(heroID: player.heroID).frame(width: 35, height: 35)
            VStack (alignment: .leading, spacing: 0) {
                ProgressView("\(Int(value))", value: percentage > 1 ? 1 : percentage, total: 1)
                    .accentColor(Color(player.slot <= 127 ? .systemGreen : .systemRed).opacity(0.8))
                    .progressViewStyle(LinearProgressViewStyle())
                    
            }
        }
    }
}
