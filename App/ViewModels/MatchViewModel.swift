//
//  MatchViewModel.swift
//  App
//
//  Created by Shibo Tong on 19/8/21.
//

import Foundation

class MatchViewModel: ObservableObject {
    @Published var match: Match?
    private var id: String
    
    init(matchid: String) {
        self.id = matchid
        self.loadMatch()
    }
    
    func loadMatch() {
        guard let match = WCDBController.shared.fetchMatch(matchid: id) else {
            print("no match found in DB")
            OpenDotaController.loadMatchData(matchid: id) { result in
                self.loadMatch()
            }
            return
        }
        self.match = match
    }
}
