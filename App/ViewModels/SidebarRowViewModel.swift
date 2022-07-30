//
//  SidebarRowViewModel.swift
//  App
//
//  Created by Shibo Tong on 17/8/21.
//

import Foundation
import CoreData
import UIKit

class SidebarRowViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var recentMatches: [RecentMatch]?
    @Published var userIcon: UIImage?
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
                Task {
                    await self.setProfile(profile)
                }
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

    private func loadUserIcon() async throws {
        guard let profile = self.profile else {
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
    
    @MainActor
    func setProfile(_ profile: UserProfile?) {
        self.profile = profile
        Task {
            try? await self.loadUserIcon()
        }
    }
    
    @MainActor
    func setMatches(_ matches: [RecentMatch]) {
        print("set matches to \(matches.count)")
        self.recentMatches = matches
    }

    @MainActor
    func setImage(_ image: UIImage) {
        self.userIcon = image
    }
}
