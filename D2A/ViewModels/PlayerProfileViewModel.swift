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
    @Published var matches: [RecentMatch] = []
    @Published var isLoading = false
    @Published var refreshing = false
    @Published var userid: String?
    @Published var userProfile: UserProfile?
    @Published var progress: Double = 0.0

    @Published var userIcon: UIImage?
    
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
        self.isLoading = true
        Task {
            await self.refreshData(refreshAll: true)
            try? await self.loadUserIcon()
        }
    }
    
    init() {
        self.matches = RecentMatch.sample
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
        guard let userid = userid else {
            return
        }
        let profile = await OpenDotaController.shared.loadUserData(userid: userid)
        if WCDBController.shared.fetchUserProfile(userid: self.userid ?? "") != nil && profile != nil {
            WCDBController.shared.insertUserProfile(profile: profile!)
        }
        await setUserProfile(profile: profile)
    }

    private func loadUserIcon() async throws {
        guard let profile = self.userProfile else {
            return
        }
        guard let imageLink = URL(string: profile.avatarfull) else {
            return
        }
        let (imageData, _) = try await URLSession.shared.data(from: imageLink)
        guard let profileImage = UIImage(data: imageData) else {
            return
        }
        await self.setImage(profileImage)
    }

    @MainActor private func setImage(_ image: UIImage) {
        self.userIcon = image
    }
    
    @MainActor private func addMatches(_ matches: [RecentMatch]) {
        self.matches = matches
        WidgetCenter.shared.reloadAllTimelines()
        self.isLoading = false
    }
    
    @MainActor private func addMoreMatches(_ matches: [RecentMatch]) {
        self.matches.append(contentsOf: matches)
    }
    
    @MainActor private func setUserProfile(profile: UserProfile?) {
        self.userProfile = profile
        WidgetCenter.shared.reloadAllTimelines()
    }
}

