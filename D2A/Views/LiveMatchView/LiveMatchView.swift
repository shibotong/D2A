//
//  LiveMatchView.swift
//  D2A
//
//  Created by Shibo Tong on 8/6/2023.
//

import SwiftUI

struct LiveMatchContainerView: View {
    @State private var matchID: String = "7195385327"
    var body: some View {
        NavigationView {
            LiveMatchView(viewModel: LiveMatchViewModel(matchID: matchID))
        }
    }
}

struct LiveMatchView: View {

    @ObservedObject var viewModel: LiveMatchViewModel
    
    var body: some View {
        VStack(spacing: 0) {
            LiveMatchTimerView(radiantScore: viewModel.radiantScore,
                               direScore: viewModel.direScore,
                               time: viewModel.time,
                               radiantTeam: viewModel.radiantTeam,
                               direTeam: viewModel.direTeam)
            LiveMatchMapView(heroes: viewModel.heroes, buildings: viewModel.buildingStatus)
            LiveMatchEventListView(events: viewModel.events)
                .padding()
                .background(Color.secondarySystemBackground)
        }
        .navigationTitle("\(viewModel.status)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LiveMatchView_Previews: PreviewProvider {
    static var previews: some View {
        LiveMatchContainerView()
    }
}
