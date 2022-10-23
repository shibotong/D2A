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
            VStack {
                ScoreView(radiantTeam: match.radiantTeam,
                          direTeam: match.direTeam,
                          radiantScore: match.radiantKill ?? 0,
                          direScore: match.direKill ?? 0,
                          time: match.duration)
                .padding(.horizontal)
                
                ScrollView {
                    MiniMapView(players: match.players,
                                buildingEvents: viewModel.towerStatus)
                    .padding(.horizontal)
                    Picker("selection", selection: $viewModel.selection) {
                        Text("Hero Detail").tag(0)
                        Text("Events").tag(1)
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)
                    if viewModel.selection == 0 {
                        MatchLiveDetailView(players: match.players, radiantScore: match.radiantKill ?? 0, direScore: match.direKill ?? 0)
                    } else {
                        EventsListView(events: viewModel.liveEvents, players: match.players)
                            .padding(.horizontal)
                    }
                }
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
