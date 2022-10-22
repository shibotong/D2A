//
//  MatchLiveDetailView.swift
//  D2A
//
//  Created by Shibo Tong on 22/10/2022.
//

import SwiftUI

struct MatchLiveDetailView: View {
    
    var players: [Player] = []
    var radiantScore: Int = 0
    var direScore: Int = 0
    
    init(players: [MatchLiveSubscription.Data.MatchLive.Player?]) {
        self.players = players.compactMap{ $0 }.map{ Player(from: $0) }
    }
    
    var body: some View {
        VStack {
            TeamView(players: players.filter{ $0.slot <= 127 }, isRadiant: true, score: radiantScore, win: nil, maxDamage: fetchMaxDamage(players: players))
            TeamView(players: players.filter{ $0.slot > 127 }, isRadiant: false, score: radiantScore, win: nil, maxDamage: fetchMaxDamage(players: players))
        }
    }
    
    func fetchMaxDamage(players: [Player]) -> Int {
        if players.first!.heroDamage != nil {
            let sortedPlayers = players.sorted(by: { $0.heroDamage ?? 0 > $1.heroDamage ?? 0})
            return sortedPlayers.first!.heroDamage!
        } else {
            return 0
        }
    }
}

struct MatchLiveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MatchLiveDetailView(players: [])
    }
}
