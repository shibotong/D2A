//
//  MatchViewModel.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation
import CoreData

class MatchListViewModel: ObservableObject {
    @Published var matches: [RecentMatch] = []
    @Published var isLoading = false
    @Published var refreshing = false
    @Published var userid: String?
    @Published var userProfile: UserProfile?
    
    init(userid: String?) {
        self.userid = userid
        self.fetchMoreData()
        guard let userid = userid else {
            return
        }
        let profile = WCDBController.shared.fetchUserProfile(userid: userid)
        self.userProfile = profile
    }
    
    func fetchMoreData() {
        guard let userid = userid else {
            return
        }
        let matches = WCDBController.shared.fetchRecentMatches(userid: userid, offSet: matches.count)
        self.matches.append(contentsOf: matches)
    }
    
    func fetchAllData() {
        guard let userid = userid else {
            return
        }
        if !self.isLoading {
            self.isLoading = true
            OpenDotaController.loadRecentMatch(userid: userid) { result in
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.fetchMoreData()
                }
            }
        }
    }
    
    func refreshData() {
        guard let userid = userid else {
            return
        }
        if !self.refreshing && !self.isLoading {
            self.refreshing = true
            let firstMatch = self.matches.first!
            let today = Date()
            let days = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(timeIntervalSince1970: TimeInterval(firstMatch.startTime)), to: today)

            let dayCount = Double(days.day!) + (Double(days.hour!) / 24.0) + (Double(days.minute!) / 60.0 / 24.0)
            OpenDotaController.loadRecentMatch(userid: userid, days: dayCount) { bool in
                DispatchQueue.main.async {
                    self.matches = WCDBController.shared.fetchRecentMatches(userid: userid)
                    self.refreshing = false
                }
            }
        }
    }
}
