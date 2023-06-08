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
    
    @Published var radiantScore: Int?
    @Published var direScore: Int?
    
    init(matchID: String) {
        guard let matchID = Int(matchID) else {
            self.matchID = 0
            return
        }
        self.matchID = matchID
        startSubscription()
    }
    
    func startSubscription() {
        subscription = Network.shared.apollo.subscribe(subscription: LiveMatchSubscription(matchid: matchID)) { result in
            switch result {
            case .success(let graphQLResult):
                let radiant = graphQLResult.data?.matchLive?.radiantScore
                let dire = graphQLResult.data?.matchLive?.direScore
                print("\(radiant) - \(dire)")
            case .failure(let error):
                print(error)
            }
        }
    }
}
