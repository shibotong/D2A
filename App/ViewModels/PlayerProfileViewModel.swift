//
//  PlayerProfileViewModel.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation
import CoreData
import WidgetKit

class PlayerProfileViewModel: ObservableObject {
    @Published var matches: [RecentMatch] = []
    @Published var isLoading = false
    @Published var refreshing = false
    @Published var userid: String?
    @Published var userProfile: UserProfile?
    @Published var progress: Double = 0.0
    
    init(userid: String?) {
        self.userid = userid
        guard let userid = userid else {
            return
        }
        let profile = WCDBController.shared.fetchUserProfile(userid: userid)
        self.userProfile = profile
    }
    
    init() {
        self.matches = RecentMatch.sample
        self.userid = "153041957"
        Task {
            await self.refreshData()
        }
    }
    
    func refreshData(refreshAll: Bool = false) async {
        self.isLoading = true
        guard let userid = userid else {
            return
        }
        let matches = await OpenDotaController.shared.loadRecentMatch(userid: userid)
        if refreshAll {
            let profile = await OpenDotaController.shared.loadUserData(userid: userid)
            await addMatches(matches, userProfile: profile)
        } else {
        // dont save match user specific to Database. Thats gonna make problem. If want to get all data, fetch from API
            await addMatches(matches, userProfile: nil)
        }
    }
    
    @MainActor private func addMatches(_ matches: [RecentMatch], userProfile: UserProfile?) {
        self.matches = matches
        if userProfile != nil {
            self.userProfile = userProfile
        }
        WidgetCenter.shared.reloadTimelines(ofKind: "AppWidget")
        self.isLoading = false
    }
    
    @MainActor private func addMoreMatches(_ matches: [RecentMatch]) {
        self.matches.append(contentsOf: matches)
    }
}

