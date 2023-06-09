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
    
    @Published var heroes: [LiveMatchHeroPosition] = []
    
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
                
                // Players
                if let players = graphQLResult.data?.matchLive?.players {
                    let heroes: [LiveMatchHeroPosition] = players.compactMap { player in
                        guard let player,
                              let heroID = player.heroId,
                              let xPos = player.playbackData?.positionEvents?.first??.x,
                              let yPos = player.playbackData?.positionEvents?.first??.y else {
                            return nil
                        }
                        
                        return LiveMatchHeroPosition(heroID: Int(heroID), xPos: CGFloat(xPos), yPos: CGFloat(yPos))
                    }
                    self?.heroes = heroes
                }
                
                // Towers
                if let towers = graphQLResult.data?.matchLive?.playbackData?.buildingEvents {
                    print(towers)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
