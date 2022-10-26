//
//  LeagueItem.swift
//  D2A
//
//  Created by Shibo Tong on 25/10/2022.
//

import SwiftUI

struct LeagueItem: View {
    
    var league: League
    
    var liveIndicator: some View {
        VStack {
            HStack {
                Spacer()
                if !(league.liveMatches?.isEmpty ?? true) {
                    LiveIndicator()
                } else {
                    EmptyView()
                }
            }
            Spacer()
        }
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            league.image
                .scaledToFill()
                .cornerRadius(5)
                .frame(height: 100)
                .clipped()
                .overlay {
                    liveIndicator
                        .padding(3)
                }
            Text(league.displayName ?? "")
                .font(.caption)
                .foregroundColor(.label)
            if let prizePool = league.prizePool, prizePool != 0 {
                Text("$\(prizePool)")
                    .font(.caption2)
                    .foregroundColor(.secondaryLabel)
            }
        }
        .frame(width: 256)
        .padding(.leading, 15)
    }
}
