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
    private var matchid: String = ""
    init(matchid: String) {
        self.loading = true
        self.matchid = matchid
    }
    
    func loadMatch() {
        print(matchid)
        OpenDotaController.loadMatchData(matchid: matchid) { match in
            self.match = match!
            DispatchQueue.main.async {
                self.loading = false
            }
        }
        self.match = Match.sample
    }
}
