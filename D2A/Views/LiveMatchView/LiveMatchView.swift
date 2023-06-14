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
        HStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    draftView
                    Spacer()
                        .frame(height: 20)
                    VStack {
                        HStack {
                            Text("Players").bold()
                                .foregroundColor(.label)
                            Spacer()
                        }
                        .padding()
                        playerView
                            .padding([.horizontal, .bottom])
                    }.background(Color.systemBackground)
                    Spacer()
                }
                .padding()
            }
            
            VStack(spacing: 0) {
                timerView
                    .background(Color.systemBackground)
                mapView
                Spacer()
                    .frame(height: 20)
                ScrollView {
                    eventView
                        .padding(.vertical)
                }.background(Color.systemBackground)
            }
            .frame(minWidth: 300, maxWidth: 400)
            .padding([.vertical, .trailing])
            
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
        .frame(height: 67)
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
        .background(Color.systemBackground)
        
    }
}
