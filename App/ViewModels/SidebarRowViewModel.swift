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
    var userid: String
    
    @Published var recentMatch: RecentMatch?
    
    init(userid: String, isRegistered: Bool = false) {
        self.userid = userid
        if userid != "" {
            self.loadProfile(isRegistered)
        }
    }
    
    func loadProfile(_ isRegistered: Bool) {
        guard let profile = WCDBController.shared.fetchUserProfile(userid: userid) else {
            Task {
                if isRegistered {
                    let profile = await OpenDotaController.shared.loadUserData(userid: userid)
                    let match = await OpenDotaController.shared.loadLatestMatch(userid: userid)
                    await self.setProfile(profile, match: match)
                } else {
                    let profile = await OpenDotaController.shared.loadUserData(userid: userid)
                    await self.setProfile(profile)
                }
            }
            return
        }
        self.profile = profile
    }
    
    @MainActor
    func setProfile(_ profile: UserProfile?, match: RecentMatch? = nil) {
        self.profile = profile
        self.recentMatch = match
    }
}
