//
//  MatchListViewModel.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import UIKit

class MatchListViewModel: ObservableObject {
    @Published var recentMatches: [RecentMatch] = []
//    @Published var loading = false
    
    private var loading = false
    private var userid = ""
    
    init(matches: [RecentMatch]) {
        recentMatches = matches
    }
    
    init (userid: String) {
        self.userid = userid
//        self.fetchMoreData()
    }
    
    func fetchMoreData() {
        if !self.loading {
            self.loading = true
            OpenDotaController.loadRecentMatch(userid: userid, offSet: recentMatches.count, limit: 10) { recentMatches in
                self.recentMatches.append(contentsOf: recentMatches)
                DispatchQueue.main.async {
                    self.loading = false
                }
            }
        }
    }
    
    func refresh() {
        DispatchQueue.main.async {
            self.recentMatches = []
        }
    }
}

class MatchListRowViewModel: ObservableObject {
    @Published var heroName: String = ""
    @Published var match: RecentMatch
    @Published var hero: Hero?
    
    init(match: RecentMatch) {
        self.match = match
        
        self.hero = HeroDatabase.shared.fetchHeroWithID(id: match.heroID)
    }
}
