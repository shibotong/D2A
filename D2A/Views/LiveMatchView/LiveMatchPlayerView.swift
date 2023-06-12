//
//  LiveMatchPlayerView.swift
//  D2A
//
//  Created by Shibo Tong on 12/6/2023.
//

import SwiftUI

struct LiveMatchPlayerView: View {
    
    let players: [PlayerRowViewModel]
    
    var body: some View {
        VStack {
            ForEach(players, id: \.accountID) { player in
                PlayerRowView(maxDamage: 100, viewModel: player)
            }
        }
    }
}
