//
//  LeagueDetailView.swift
//  D2A
//
//  Created by Shibo Tong on 25/10/2022.
//

import SwiftUI

struct LeagueDetailView: View {
    
    var league: League
    
    @Environment (\.horizontalSizeClass) private var horizontalSize
    
    var banner: some View {
        ZStack {
            league.image.scaledToFill().blur(radius: 100)
            Color.systemBackground.opacity(0.5)
            if horizontalSize == .compact {
                VStack {
                    league.image.scaledToFit()
                    Text(league.displayName ?? "")
                        .font(.title)
                        .bold()
                }
                .padding()
            } else {
                HStack {
                    league.image.scaledToFit()
                    Text(league.displayName ?? "")
                        .font(.title)
                        .bold()
                }
            }
        }
    }
        
    var body: some View {
        ScrollView {
            banner
                .frame(height: 200)
                .clipped()
        }
        .navigationTitle(league.displayName ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
}
