//
//  LiveMatchView.swift
//  D2A
//
//  Created by Shibo Tong on 8/6/2023.
//

import SwiftUI

struct LiveMatchView: View {

    @ObservedObject var viewModel: LiveMatchViewModel
    @State var showActivity = false
    @State var showPlayer = false
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        ZStack {
            if horizontalSizeClass == .compact {
                verticalView
            } else {
                horizontalView
            }
        }
        .navigationTitle("\(viewModel.status)")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            viewModel.startFetching()
        }
        .onDisappear(perform: viewModel.removeSubscription)
    }
    
    private var horizontalView: some View {
        VStack(spacing: 0) {
            timerView
                .frame(height: 100)
            HStack(spacing: 16) {
                ScrollView(showsIndicators: false) {
                    VStack {
                        draftView
                            .background(Color.secondarySystemBackground)
                        buildPlayerView()
                            .background(Color.secondarySystemBackground)
                    }.padding(.top)
                }
                ScrollView(showsIndicators: false) {
                    VStack {
                        mapView
                        eventView
                            .padding(.vertical)
                            .background(Color.secondarySystemBackground)
                    }.padding(.top)
                }
                .frame(width: 350)
            }
            .padding([.horizontal])
        }
        .background(Color.systemBackground)
    }
    
    private var verticalView: some View {
        VStack(spacing: 0) {
            timerView
                .frame(height: 80)
            ScrollView {
                VStack {
                    mapView
                    draftView
                        .background(Color.systemBackground)
                    Picker("What is your favorite color?", selection: $showActivity) {
                        Text("Players").tag(false)
                        Text("Events").tag(true)
                    }
                    .pickerStyle(.segmented)
                    if showActivity {
                        eventView
                    } else {
                        buildPlayerView()
                    }
                }
            }
            .background(Color.systemBackground)
        }
        .background(Color.secondarySystemBackground)
    }
    
    private var timerView: some View {
        LiveMatchTimerView(radiantScore: viewModel.radiantScore,
                           direScore: viewModel.direScore,
                           time: viewModel.time,
                           radiantTeam: viewModel.radiantTeam,
                           direTeam: viewModel.direTeam)
    }
    
    private var eventView: some View {
        LiveMatchEventListView(events: viewModel.events)
            .padding(.horizontal)
    }
    
    private var mapView: some View {
        LiveMatchMapView(heroes: viewModel.heroesPosition, buildings: viewModel.buildingStatus)
    }
    
    private var draftView: some View {
        LiveMatchDraftView(radiantPick: viewModel.radiantPick,
                           radiantBan: viewModel.radiantBan,
                           direPick: viewModel.direPick,
                           direBan: viewModel.direBan,
                           winRate: viewModel.draftWinRate,
                           hasBan: viewModel.hasBan,
                           showDetail: $viewModel.showDraft)
    }
    
    @ViewBuilder private func buildPlayerView() -> some View {
        LiveMatchPlayerView(players: viewModel.matchPlayers)
            .padding()
    }
}

struct LiveMatchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LiveMatchView(viewModel: .init(matchID: "7224708614"))
        }
    }
}
