//
//  LiveMatchView.swift
//  D2A
//
//  Created by Shibo Tong on 8/6/2023.
//

import SwiftUI

struct LiveMatchContainerView: View {
    @State private var matchID: String = "7193432323"
    var body: some View {
        VStack {
            LiveMatchView(viewModel: LiveMatchViewModel(matchID: matchID))
            Spacer()
        }
        
    }
}

struct LiveMatchView: View {

    @ObservedObject var viewModel: LiveMatchViewModel
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                LiveMatchTimerView(radiantScore: viewModel.radiantScore, direScore: viewModel.direScore, time: viewModel.time)
                LiveMatchMapView(heroes: viewModel.heroes, buildings: viewModel.buildingStatus)
            }
            .padding()
        }
    }
}

struct LiveMatchView_Previews: PreviewProvider {
    static var previews: some View {
        LiveMatchContainerView()
    }
}
