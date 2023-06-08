//
//  LiveMatchView.swift
//  D2A
//
//  Created by Shibo Tong on 8/6/2023.
//

import SwiftUI

struct LiveMatchContainerView: View {
    @State private var matchID: String = ""
    @State private var showMatch = false
    var body: some View {
        VStack {
            
            if showMatch {
                LiveMatchView(showMatch: $showMatch, viewModel: LiveMatchViewModel(matchID: matchID))
            } else {
                Button("Enter Live Match") {
                    print("match id: \(matchID)")
                    showMatch = true
                }
                TextField("Enter match ID", text: $matchID)
            }
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
            LiveMatchTimerView(radiantScore: viewModel.radiantScore, direScore: viewModel.direScore, time: viewModel.time)
        }
    }
}

struct LiveMatchView_Previews: PreviewProvider {
    static var previews: some View {
        LiveMatchContainerView()
    }
}
