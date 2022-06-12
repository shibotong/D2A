//
//  SidebarRowViewModel.swift
//  App
//
//  Created by Shibo Tong on 17/8/21.
//

import Foundation
import CoreData

class SidebarRowViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var recentMatches: [RecentMatch]?
    var userid: String
    private var isRegistered: Bool
    
    init(userid: String, isRegistered: Bool = false) {
        print("init \(userid)")
        self.userid = userid
        self.isRegistered = isRegistered
        self.loadProfile()
        if isRegistered {
            self.loadMatches()
        }
    }
    
    func loadProfile() {
        if self.profile == nil {
            if let profile = WCDBController.shared.fetchUserProfile(userid: userid) {
                self.profile = profile
            } else {
                Task {
                    let profile = await OpenDotaController.shared.loadUserData(userid: userid)
                    await self.setProfile(profile)
                }
            }
        }
    }
    
    func loadMatches() {
        if self.recentMatches == nil {
            Task {
                let matches = await OpenDotaController.shared.loadRecentMatches(userid: userid)
                await self.setMatches(matches)
            }
        }
    }
    
    @MainActor
    func setProfile(_ profile: UserProfile?) {
        self.profile = profile
    }
    
    @MainActor
    func setMatches(_ matches: [RecentMatch]) {
        print("set matches to \(matches.count)")
        self.recentMatches = matches
    }
}
