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
    @Published var selection: RecentMatch?
    @Published var userProfile: SteamProfile?
    
    private var loading = false
    private var userid = ""
    
    private var loadingMatch = false
    
    init(matches: [RecentMatch]) {
        recentMatches = matches
    }
    
    init (userid: String) {
        self.userid = userid
        self.fetchUserProfile()
    }
    
    func fetchUserProfile() {
        self.loading = true
        OpenDotaController.loadUserData(userid: userid) { profile in
            DispatchQueue.main.async {
                self.userProfile = profile
                self.loading = false
            }
            self.fetchMoreData()
        }
    }
    
    func fetchMoreData() {
        if !self.loadingMatch {
            self.loadingMatch = true
            OpenDotaController.loadRecentMatch(userid: userid, offSet: recentMatches.count, limit: 10) { recentMatches in
                self.recentMatches.append(contentsOf: recentMatches)
                DispatchQueue.main.async {
                    self.loadingMatch = false
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
