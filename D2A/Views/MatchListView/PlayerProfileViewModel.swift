//
//  PlayerProfileViewModel.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation
import CoreData
import WidgetKit
import UIKit

class PlayerProfileViewModel: ObservableObject {
    @Published var matches: [RecentMatchCodable] = []
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
        if let profile = UserProfile.fetch(id: userid) {
            self.userProfile = profile
        } else {
            Task {
                await self.loadUserProfile()
            }
        }
        self.isLoading = true
        Task {
            await self.refreshData(refreshAll: true)
        }
    }
    
    init() {
        self.matches = RecentMatchCodable.sample
        self.userid = "153041957"
        Task {
            await self.refreshData(refreshAll: true)
        }
    }
    
    func refreshData(refreshAll: Bool = false) async {
        guard let userid = userid else {
            return
        }
        async let matches = OpenDotaController.shared.loadRecentMatches(userid: userid)
        if refreshAll {
            await self.loadUserProfile()
        }
        // dont save match user specific to Database. Thats gonna make problem. If want to get all data, fetch from API
        await addMatches(matches)
    }
    
    func loadUserProfile() async {
        guard let userid = userid,
              let profileCodable = try? await OpenDotaController.shared.loadUserData(userid: userid),
              let profile = try? UserProfile.create(profileCodable) else {
            return
        }
        await setUserProfile(profile: profile)
    }
    
    @MainActor private func addMatches(_ matches: [RecentMatchCodable]) {
        self.matches = matches
        WidgetCenter.shared.reloadAllTimelines()
        self.isLoading = false
    }
    
    @MainActor private func addMoreMatches(_ matches: [RecentMatchCodable]) {
        self.matches.append(contentsOf: matches)
    }
    
    @MainActor private func setUserProfile(profile: UserProfile?) {
        self.userProfile = profile
        WidgetCenter.shared.reloadAllTimelines()
    }
}

