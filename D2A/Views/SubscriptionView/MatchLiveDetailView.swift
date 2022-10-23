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
    
    var body: some View {
        VStack {
            TeamView(players: players.filter{ $0.slot <= 127 }, isRadiant: true, score: radiantScore, radiantWin: nil, maxDamage: fetchMaxDamage(players: players), canClick: false)
            TeamView(players: players.filter{ $0.slot > 127 }, isRadiant: false, score: direScore, radiantWin: nil, maxDamage: fetchMaxDamage(players: players), canClick: false)
        }
    }
    
    func fetchMaxDamage(players: [Player]) -> Int? {
        guard players.first?.heroDamage != nil else {
            return nil
        }
        let sortedPlayers = players.sorted(by: { $0.heroDamage ?? 0 > $1.heroDamage ?? 0})
        return sortedPlayers.first!.heroDamage!
    }
}

struct MatchLiveDetailView_Previews: PreviewProvider {
    static var previews: some View {
        MatchLiveDetailView(players: [])
    }
}
