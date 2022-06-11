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
        if let profile = WCDBController.shared.fetchUserProfile(userid: userid) {
            self.userProfile = profile
        } else {
            Task {
                await self.loadUserProfile()
            }
        }
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
        async let matches = OpenDotaController.shared.loadRecentMatch(userid: userid)
        if refreshAll {
            await self.loadUserProfile()
        }
        // dont save match user specific to Database. Thats gonna make problem. If want to get all data, fetch from API
        await addMatches(matches)
    }
    
    func loadUserProfile() async {
        guard let userid = userid else {
            return
        }
        let profile = await OpenDotaController.shared.loadUserData(userid: userid)
        await setUserProfile(profile: profile)
    }
    
    @MainActor private func addMatches(_ matches: [RecentMatch]) {
        self.matches = matches
        WidgetCenter.shared.reloadTimelines(ofKind: "AppWidget")
        self.isLoading = false
    }
    
    @MainActor private func addMoreMatches(_ matches: [RecentMatch]) {
        self.matches.append(contentsOf: matches)
    }
    
    @MainActor private func setUserProfile(profile: UserProfile?) {
        self.userProfile = profile
        WidgetCenter.shared.reloadTimelines(ofKind: "AppWidget")
    }
}

