//
//  AnalysisView.swift
//  App
//
//  Created by Shibo Tong on 16/8/21.
//

import SwiftUI

struct AnalysisView: View {
    var players: [Player]
    @State private var selection: AnalysisType = .kills
    var body: some View {
        VStack {
            HStack {
                Text("Analysis").font(.custom(fontString, size: 20)).bold()
                Spacer()
                HStack {
                    Menu {
                        Picker("picker", selection: $selection) {
                            Text("Tower Damage").tag(AnalysisType.towerDamage)
                            Text("Hero Damage").tag(AnalysisType.heroDamage)
                            Text("Net Worth").tag(AnalysisType.golds)
                            Text("Kills").tag(AnalysisType.kills)
                        }
                    } label: {
                        Label("\(selection.rawValue)", systemImage: "chevron.down")
                    }
                }.font(.custom(fontString, size: 15)).foregroundColor(Color(.secondaryLabel))
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.secondarySystemBackground)))
            }
            if sortBy(analysisType: selection) != nil {
                ForEach(sortBy(analysisType: selection)!, id: \.heroID) { player in
                    PlayerAnalysisRowView(player: player, percentage:calculatePercentage(currentPlayer: player, firstPlayer: sortBy(analysisType: selection)!.first!), selection: $selection)
                }
            }
        }.padding(20)
    }
    
    private func calculatePercentage(currentPlayer: Player, firstPlayer: Player) -> Double {
        switch selection {
        case .golds:
            return Double(currentPlayer.netWorth!) / Double(firstPlayer.netWorth!)
        case .heroDamage:
            return Double(currentPlayer.heroDamage) / Double(firstPlayer.heroDamage)
        case .kills:
            return Double(currentPlayer.kills) / Double(firstPlayer.kills)
        case .towerDamage:
            return Double(currentPlayer.towerDamage) / Double(firstPlayer.towerDamage)
        }
    }
    
    private func sortBy(analysisType: AnalysisType) -> [Player]? {
        switch analysisType {
        case .golds:
            if players.allSatisfy({ $0.netWorth != nil }) {
                return players.sorted(by: { $0.netWorth! >= $1.netWorth! })
            } else {
                return nil
            }
        case .heroDamage:
            return players.sorted(by: { $0.heroDamage >= $1.heroDamage })
        case .kills:
            return players.sorted(by: { $0.kills >= $1.kills })
        case .towerDamage:
            return players.sorted(by: { $0.towerDamage >= $1.towerDamage })
        }
    }
}

enum AnalysisType: String {
    case kills = "Kills"
    case golds = "Golds"
    case heroDamage = "Hero Damage"
    case towerDamage = "Tower Damage"
    
}

struct AnalysisView_Previews: PreviewProvider {
    static var previews: some View {
        AnalysisView(players: Match.sample.players)
    }
}

struct PlayerAnalysisRowView: View {
    var player: Player
    var percentage: Double
    @Binding var selection: AnalysisType
    
    var body: some View {
        HStack {
            Image("hero_icon")
            VStack (alignment: .leading, spacing: 0) {
                ProgressView("\(detailNumber())", value: percentage, total: 1)
                    .accentColor(Color(player.slot <= 127 ? .systemGreen : .systemRed).opacity(0.8))
                    .progressViewStyle(LinearProgressViewStyle())
                    
            }
        }
    }
    
    private func detailNumber() -> Int {
        switch selection {
        case .golds:
            return player.netWorth!
        case .heroDamage:
            return player.heroDamage
        case .kills:
            return player.kills
        case .towerDamage:
            return player.towerDamage
        }
    }
    
}
