//
//  LiveMatchViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 8/6/2023.
//

import Foundation
import StratzAPI
import Apollo

class LiveMatchViewModel: ObservableObject {
    var subscription: Cancellable?
    
    private let matchID: Int
    
    // LiveMatchTimerView
    @Published var radiantScore: Int?
    @Published var direScore: Int?
    @Published var time: Int?
    
    init(matchID: String) {
        guard let matchID = Int(matchID) else {
            self.matchID = 0
            return
        }
        self.matchID = matchID
        startSubscription()
    }
    
    func startSubscription() {
        subscription = Network.shared.apollo.subscribe(subscription: LiveMatchSubscription(matchid: matchID)) { [weak self] result in
            switch result {
            case .success(let graphQLResult):
                self?.radiantScore = graphQLResult.data?.matchLive?.radiantScore
                self?.direScore = graphQLResult.data?.matchLive?.direScore
                self?.time = graphQLResult.data?.matchLive?.gameTime
            case .failure(let error):
                print(error)
            }
        }
    }
}
