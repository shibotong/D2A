//
//  MatchLiveView.swift
//  D2A
//
//  Created by Shibo Tong on 22/10/2022.
//

import SwiftUI

struct MatchLiveView: View {
    
    @ObservedObject var viewModel: MatchLiveViewModel
    
    init(matchID: Int) {
        viewModel = .init(matchID: matchID)
        viewModel.startFetching()
    }
    
    var body: some View {
        if let match = viewModel.matchLive {
            ScrollView {
                VStack {
                    HeroBanner(players: match.players ?? [])
                    ScoreView(radiantScore: match.radiantScore ?? 0,
                              direScore: match.direScore ?? 0,
                              time: match.gameTime ?? 0)
                    MiniMapView(players: match.players,
                                buildingState: match.buildingState)
                    MatchLiveDetailView(players: match.players ?? [])
                }
                .padding()
            }
        } else {
            VStack {
                ProgressView()
                Text("LOADING")
            }
        }
    }
}

struct MatchLiveView_Previews: PreviewProvider {
    static var previews: some View {
        MatchLiveView(matchID: 153049157)
    }
}
