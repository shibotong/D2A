//
//  Environment.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation

class DotaEnvironment: ObservableObject {
    
    
    
    @Published var userIDs: [String] {
        didSet {
            UserDefaults.standard.set(userIDs, forKey: "dotaArmory.userID")
        }
    }
    @Published var selectedUserProfile: SteamProfile?
    @Published var selectedRecentMatches: [RecentMatch] = []
    @Published var selectedGame: Match? = nil
    
    @Published var loadingMatches = false
    
    init() {
        self.userIDs = UserDefaults.standard.object(forKey: "dotaArmory.userID") as? [String] ?? ["153041957", "116232078"]
        if userIDs.isEmpty {
            print("no user")
        } else {
            self.loadUser(id: userIDs.first!)
        }
    }
    
    func loadUser(id: String) {
        guard let currentProfile = self.selectedUserProfile else {
            OpenDotaController.loadUserData(userid: id) { profile in
                DispatchQueue.main.async {
                    self.selectedUserProfile = profile
                    
                }
            }
            return
        }
        if currentProfile.profile.id == Int(id) {
            // same user do nothing
        } else {
            self.selectedUserProfile = nil
            self.selectedRecentMatches = []
            OpenDotaController.loadUserData(userid: id) { profile in
                DispatchQueue.main.async {
                    self.selectedUserProfile = profile
                    
                }
            }
        }
    }
    
    private func loadMatch(match: RecentMatch) {
        OpenDotaController.loadMatchData(matchid: "\(match.id)") { match in
            self.selectedGame = match!
        }
    }
    
    func fetchMoreData() {
        if !self.loadingMatches {
            self.loadingMatches = true
            guard let profile = selectedUserProfile?.profile else {
                return
            }
            OpenDotaController.loadRecentMatch(userid: "\(profile.id)", offSet: selectedRecentMatches.count, limit: 10) { recentMatches in
                self.selectedRecentMatches.append(contentsOf: recentMatches)
                if self.selectedGame == nil && !recentMatches.isEmpty {
                    self.loadMatch(match: recentMatches.first!)
                }
                DispatchQueue.main.async {
                    self.loadingMatches = false
                }
            }
        }
    }
}
