//
//  LiveMatchView.swift
//  D2A
//
//  Created by Shibo Tong on 8/6/2023.
//

import SwiftUI

struct LiveMatchContainerView: View {
    @State private var matchID: String = "7192774491"
    @State private var showMatch = false
    var body: some View {
        VStack {
            
//            if showMatch {
                LiveMatchView(showMatch: $showMatch, viewModel: LiveMatchViewModel(matchID: matchID))
            // x13.5
            // y
//            } else {
//                Button("Enter Live Match") {
//                    print("match id: \(matchID)")
//                    showMatch = true
//                }
//                TextField("Enter match ID", text: $matchID)
//            }
            Spacer()
        }
        
    }
}

struct LiveMatchView: View {
    
    @Binding var showMatch: Bool
    @ObservedObject var viewModel: LiveMatchViewModel
    
    var body: some View {
        ScrollView {
            Button("Quit match") {
                viewModel.subscription?.cancel()
                viewModel.subscription = nil
                showMatch = false
            }
            VStack(spacing: 0) {
                LiveMatchTimerView(radiantScore: viewModel.radiantScore, direScore: viewModel.direScore, time: viewModel.time)
                LiveMatchMapView(heroes: viewModel.heroes)
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
