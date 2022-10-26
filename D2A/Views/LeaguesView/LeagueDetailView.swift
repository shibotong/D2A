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
            league.image.blur(radius: 100)
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
                .ignoresSafeArea()
                .clipped()
            if let liveMatches = league.liveMatches, !liveMatches.isEmpty {
                buildLiveMatches(matches: liveMatches.compactMap { $0 }.filter { $0.completed == false })
            }
        }
        .navigationTitle(league.displayName ?? "")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    @ViewBuilder private func buildLiveMatches(matches: [LeagueLiveMatch]) -> some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Live")
            ForEach(matches, id:\.matchId) { match in
                if let matchID = match.matchId, let parsing = match.isParsing {
                    MatchLiveRowView(matchID: matchID, isParsing: parsing)
                        .frame(height: 110)
                }
            }
        }
        .padding()
    }

    
}
