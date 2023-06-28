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
            GeometryReader { proxy in
                let width = proxy.size.width
                if width >= 600 {
                    HStack {
                        ScrollView {
                            draftView
                            mapView
                        }
                        ScrollView {
                            eventView
                                .padding(.vertical)
                        }
                        ScrollView {
                            playerView
                                .padding(.vertical)
                        }
                    }
                } else {
                    HStack {
                        ScrollView {
                            draftView
                            mapView
                        }
                        VStack {
                            Picker("ShowPlayer", selection: $showPlayer) {
                                Text("Events")
                                    .tag(false)
                                Text("Players")
                                    .tag(true)
                            }
                            .pickerStyle(.segmented)
                            ScrollView {
                                if showPlayer {
                                    playerView
                                } else {
                                    eventView
                                }
                            }
                        }
                        .padding(.top)
                    }
                }
            }
        }
        .background(Color.secondarySystemBackground)
    }
    
    private var verticalView: some View {
        VStack(spacing: 0) {
            timerView
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
                        playerView
                    }
                }
            }
            .background(Color.systemBackground)
        }
        .background(Color.secondarySystemBackground)
    }
    
    private var playerView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            LiveMatchPlayerView(players: viewModel.matchPlayers)
                .padding(.horizontal)
        }
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
}

struct LiveMatchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmptyView()
            LiveMatchView(viewModel: .init(matchID: "7219319154"))
        }
    }
}
