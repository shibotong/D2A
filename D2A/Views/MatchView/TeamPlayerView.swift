//
//  TeamPlayerView.swift
//  D2A
//
//  Created by Shibo Tong on 18/2/2024.
//

import SwiftUI

struct TeamView: View {
    var players: [PlayerRowViewModel]
    var isRadiant: Bool
    var score: Int
    var win: Bool
    var maxDamage: Int
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        VStack {
            TeamHeaderView(isRadiant: isRadiant, win: win)
            ForEach(players, id: \.slot) { player in
                PlayerRowView(maxDamage: maxDamage, viewModel: player)
                    .padding(.horizontal)
            }
        }
        
    }
}

#Preview {
    TeamView(players: [
        .init(player: .init(id: "1", slot: 1)),
        .init(player: .init(id: "2", slot: 2))
    ], isRadiant: true, score: 10, win: true, maxDamage: 2000)
}
