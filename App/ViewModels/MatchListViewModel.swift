//
//  MatchViewModel.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation
import CoreData
import WidgetKit

class MatchListViewModel: ObservableObject {
    @Published var matches: [RecentMatch] = []
    @Published var isLoading = false
    @Published var refreshing = false
    @Published var userid: String?
    @Published var userProfile: UserProfile?
    @Published var progress: Double = 0.0
    
    init(userid: String?) {
        self.userid = userid
        self.fetchMoreData()
        guard let userid = userid else {
            return
        }
        let profile = WCDBController.shared.fetchUserProfile(userid: userid)
        self.userProfile = profile
        self.loadMatchData()
    }
    
    init() {
        self.matches = RecentMatch.sample
        self.userid = "0"
    }
    
    func fetchMoreData() {
        guard let userid = userid else {
            return
        }
        let matches = WCDBController.shared.fetchRecentMatches(userid: userid, offSet: matches.count)
        self.matches.append(contentsOf: matches)
    }
    
    func loadMatchData() {
        guard let userid = userid else {
            return
        }
        let matches = WCDBController.shared.fetchRecentMatches(userid: userid)
        self.matches = matches
    }
    
    func refreshData() async {
        guard let userid = userid else {
            return
        }
        let profile = await OpenDotaController.shared.loadUserData(userid: userid)
        if let firstMatch = WCDBController.shared.fetchRecentMatches(userid: userid).first {
            // have previous data
            let today = Date()
            let days = Calendar.current.dateComponents([.day, .hour, .minute, .second], from: Date(timeIntervalSince1970: TimeInterval(firstMatch.startTime)), to: today)
            let dayCount = Double(days.day!) + (Double(days.hour!) / 24.0) + (Double(days.minute!) / 60.0 / 24.0)
            let matches = await OpenDotaController.shared.loadRecentMatch(userid: userid, days: dayCount)
            await addMatches(matches, userProfile: profile?.profile)
        } else {
            let matches = await OpenDotaController.shared.loadRecentMatch(userid: userid)
            await addMatches(matches, userProfile: profile?.profile)
        }
    }
    
    @MainActor private func addMatches(_ matches: [RecentMatch], userProfile: UserProfile?) {
        self.matches.insert(contentsOf: matches, at: 0)
        if userProfile != nil {
            self.userProfile = userProfile
        }
        WidgetCenter.shared.reloadTimelines(ofKind: "AppWidget")
    }
}

