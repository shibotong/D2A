//
//  MatchLiveView.swift
//  D2A
//
//  Created by Shibo Tong on 22/10/2022.
//

import SwiftUI

struct MatchLiveView: View {
    
    @ObservedObject var viewModel: MatchLiveViewModel
    @Environment (\.horizontalSizeClass) private var horizontal
    
    init(matchID: Int) {
        viewModel = .init(matchID: matchID)
        viewModel.startFetching()
    }
    
    init(viewModel: MatchLiveViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        if let match = viewModel.matchLive {
            buildmain(match: match)
                .navigationTitle("\(match.radiantTeam?.name ?? "") vs \(match.direTeam?.name ?? "")")
        } else {
            VStack {
                ProgressView()
                Text("LOADING")
            }
        }
    }
    
    @ViewBuilder private func buildmain(match: Match) -> some View {
        if horizontal == .compact {
            compactMain(match: match)
        } else {
            regularMain(match: match)
        }
    }
    
    @ViewBuilder private func regularMain(match: Match) -> some View {
        HStack(spacing: 0) {
            VStack {
                LiveDraftView(drafts: viewModel.drafts)
                    .padding(.horizontal)
                    .frame(height: 150)
                ScrollView {
                    MatchLiveDetailView(players: match.players, radiantScore: match.radiantKill ?? 0, direScore: match.direKill ?? 0)
                }
            }
            VStack(spacing: 20) {
                VStack(spacing: 0) {
                    ScoreView(radiantTeam: match.radiantTeam,
                              direTeam: match.direTeam,
                              radiantScore: match.radiantKill ?? 0,
                              direScore: match.direKill ?? 0,
                              time: match.duration)
                    MiniMapView(players: match.players,
                                buildingEvents: match.buildings)
                    .frame(height: 300)
                }
                .background(Color.secondarySystemBackground)
                .cornerRadius(5)
                .clipped()
                ScrollView {
                    EventsListView(events: viewModel.liveEvents, players: match.players)
                        .padding(.horizontal)
                }
                .background(Color.secondarySystemBackground)
                .cornerRadius(5)
                .clipped()
            }.frame(width: 300)
        }
    }
    
    @ViewBuilder private func compactMain(match: Match) -> some View {
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
                    Text("Drafts").tag(0)
                    Text("Hero Detail").tag(1)
                    Text("Events").tag(2)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)
                if viewModel.selection == 0 {
                    LiveDraftView(drafts: viewModel.drafts)
                        .padding(.horizontal)
                        .frame(height: 250)
                } else if viewModel.selection == 1 {
                    MatchLiveDetailView(players: match.players, radiantScore: match.radiantKill ?? 0, direScore: match.direKill ?? 0)
                } else if viewModel.selection == 2 {
                    EventsListView(events: viewModel.liveEvents, players: match.players)
                        .padding(.horizontal)
                }
            }
            .clipped()
        }
    }
}

struct MatchLiveView_Previews: PreviewProvider {
    static var previews: some View {
        MatchLiveView(matchID: 153049157)
    }
}
