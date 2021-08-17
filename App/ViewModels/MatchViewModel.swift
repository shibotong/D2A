//
//  MatchViewModel.swift
//  App
//
//  Created by Shibo Tong on 12/8/21.
//

import Foundation

class MatchViewModel: ObservableObject {
    @Published var match: Match = Match.sample
    @Published var loading = false
    @Published var recentMatch: RecentMatch
    var matchid: String = ""
    init(match: RecentMatch) {
        self.loading = true
        self.matchid = "\(match.id)"
        self.recentMatch = match
//        self.loadMatch()
    }
    
    init(previewMatch: Match) {
        self.match = previewMatch
        self.loading = false
        self.recentMatch = RecentMatch.sample.first!
    }
    
    func loadMatch() {
        print("load match: \(matchid)")
        OpenDotaController.loadMatchData(matchid: matchid) { match in
            DispatchQueue.main.async {
                self.match = match!
                self.loading = false
            }
        }
        
    }
}
