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
            if players.isEmpty {
                ForEach(0...9, id: \.self) { _ in
                    PlayerRowEmptyView()
                }
            } else {
                ForEach(players, id: \.accountID) { player in
                    PlayerRowView(maxDamage: 0, viewModel: player)
                }
            }
        }
    }
}

struct PlayerRowEmptyView: View {
    
    private let foregroundColor: Color = .black.opacity(0.3)
    
    var body: some View {
        HStack {
            Circle()
                .foregroundColor(foregroundColor)
                .frame(width: 35, height: 35)
            RoundedRectangle(cornerRadius: 5)
                .frame(width: 500, height: 30)
                .foregroundColor(foregroundColor)
                .frame(height: 50)
        }
    }
}

 struct LiveMatchPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            
            LiveMatchPlayerView(players: [])
        }
    }
 }
