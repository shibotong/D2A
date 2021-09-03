//
//  MatchViewModel.swift
//  App
//
//  Created by Shibo Tong on 19/8/21.
//

import Foundation

class MatchViewModel: ObservableObject {
    @Published var match: Match?
    @Published var loading = false
    @Published var id: String?
    
    init(matchid: String?) {
        self.id = matchid
        self.loadMatch()
    }
    
    init() {
        self.id = "0"
        self.match = Match.sample
    }
    
    func loadMatch() {
        guard let id = self.id else {
            return
        }
        guard let match = WCDBController.shared.fetchMatch(matchid: id) else {
            return
        }
        self.match = match

    }
    
    func loadNewMatch() {
        print("load new match")
        if self.match == nil {
            guard let match = WCDBController.shared.fetchMatch(matchid: id!) else {
                OpenDotaController.loadMatchData(matchid: id!) { result in
                    self.loadNewMatch()
                }
                return
            }
            DispatchQueue.main.async {
                self.match = match
            }
        }
    }
    
    func refresh() {
        if !self.loading {
            self.loading = true
            OpenDotaController.loadMatchData(matchid: id!) { result in
                self.loadMatch()
                self.loading = false
            }
        }
    }
    
    func fetchGameMode(id: Int) -> GameMode {
        return HeroDatabase.shared.fetchGameMode(id: id)
    }
    
    func fetchGameRegion(id: String) -> String {
        return HeroDatabase.shared.fetchRegion(id: id)
    }
}
