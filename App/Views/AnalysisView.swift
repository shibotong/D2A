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
                            Text("Golds").tag(AnalysisType.golds)
                            Text("Kills").tag(AnalysisType.kills)
                        }
                    } label: {
                        Label("\(selection.rawValue)", systemImage: "chevron.down")
                    }
                }.font(.custom(fontString, size: 15)).foregroundColor(Color(.secondaryLabel))
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(RoundedRectangle(cornerRadius: 10).foregroundColor(Color(.secondarySystemBackground)))
            }.padding(20)
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
