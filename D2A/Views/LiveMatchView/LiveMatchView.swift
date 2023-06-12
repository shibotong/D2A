//
//  LiveMatchView.swift
//  D2A
//
//  Created by Shibo Tong on 8/6/2023.
//

import SwiftUI

struct LiveMatchContainerView: View {
    @State private var matchID: String = "7196512086"
    var body: some View {
        LiveMatchView(viewModel: LiveMatchViewModel(matchID: matchID))
    }
}

struct LiveMatchView: View {

    @ObservedObject var viewModel: LiveMatchViewModel
    
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
    }
    
    private var horizontalView: some View {
        HStack(spacing: 20) {
            VStack {
                draftView
                Spacer()
            }
            VStack(spacing: 0) {
                timerView
                mapView
                Spacer()
                    .frame(height: 20)
                ScrollView {
                    eventView
                        .padding(.vertical)
                }.background(Color.secondarySystemBackground)
            }
            .frame(minWidth: 300, maxWidth: 400)
        }
        .padding()
    }
    
    private var verticalView: some View {
        VStack(spacing: 0) {
            timerView
            ScrollView {
                VStack {
                    draftView
                    mapView
                    eventView
                }
                .padding(.vertical, 9)
            }
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
        LiveMatchMapView(heroes: viewModel.heroes, buildings: viewModel.buildingStatus)
    }
    
    private var draftView: some View {
        LiveMatchDraftView(radiantPick: viewModel.radiantPick,
                           radiantBan: viewModel.radiantBan,
                           direPick: viewModel.direPick,
                           direBan: viewModel.direBan,
                           showDetail: viewModel.status == "Hero Selection")
        
    }
}

struct LiveMatchView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            EmptyView()
            LiveMatchContainerView()
        }
    }
}
