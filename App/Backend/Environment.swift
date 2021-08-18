//
//  Environment.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation

class DotaEnvironment: ObservableObject {
    
    static var shared = DotaEnvironment()
    
    @Published var userIDs: [String] {
        didSet {
            UserDefaults.standard.set(userIDs, forKey: "dotaArmory.userID")
        }
    }
    @Published var selectedUserProfile: SteamProfile?
    @Published var selectedRecentMatches: [RecentMatch] = []
    @Published var selectedGame: Match? = nil
    
    @Published var selectedUserID: String? = nil
    @Published var selectedGameID: Int? = nil
    
    @Published var loadingMatches = false
    
    @Published var loadingProfile = false
    @Published var loadingGame = false
    
    @Published var exceedLimit = false
    
    init() {
        self.userIDs = UserDefaults.standard.object(forKey: "dotaArmory.userID") as? [String] ?? ["116232078", "153041957"]
        if userIDs.isEmpty {
            print("no user")
        } else {
//            self.loadUser(id: userIDs.first!)
        }
    }
    
    private func fetchFirstMatch() {
        guard (selectedUserProfile?.profile) != nil else {
            return
        }
//        OpenDotaController.loadRecentMatch(userid: "\(profile.id)", offSet: selectedRecentMatches.count, limit: 50) { recentMatches in
////            self.selectedRecentMatches.append(contentsOf: recentMatches)
////            if self.selectedGame == nil && !recentMatches.isEmpty {
//                self.loadMatch(match: recentMatches.first!)
////            }
////            DispatchQueue.main.async {
////                self.loadingMatches = false
////            }
//        }
    }
    
//    func loadUser(id: String) {
//        self.selectedUserID = id
//        guard let currentProfile = self.selectedUserProfile else {
//                OpenDotaController.loadUserData(userid: id) { profile in
//                    DispatchQueue.main.async {
//                        self.selectedUserProfile = profile
//                        self.fetchFirstMatch()
//                    }
//                    
//                }
//            return
//        }
//        if currentProfile.profile!.id == Int(id)! {
//            // same user do nothing
//        } else {
//                self.selectedUserProfile = nil
//                self.selectedRecentMatches = []
//                OpenDotaController.loadUserData(userid: id) { profile in
//                    DispatchQueue.main.async {
//                        self.selectedUserProfile = profile
//                    }
//                    self.fetchMoreData()
//                }
//        }
//    }
    
    func loadMatch(match: RecentMatch) {
        self.selectedGameID = Int(match.id)
        print(selectedGameID)
        guard let currentMatch = self.selectedGame else {
            self.loadingGame = true
            OpenDotaController.loadMatchData(matchid: "\(match.id)") { match in
                DispatchQueue.main.async {
                    self.loadingGame = false
                    self.selectedGame = match
                }
                
            }
            return
        }
        if currentMatch.id == match.id {
            // same match
        } else {
            self.loadingGame = true
            OpenDotaController.loadMatchData(matchid: "\(match.id)") { match in
                DispatchQueue.main.async {
                    self.loadingGame = false
                    self.selectedGame = match
                }
                
            }
        }
    }
    
    func fetchMoreData() {
        if !self.loadingMatches {
            self.loadingMatches = true
            guard let profile = selectedUserProfile?.profile else {
                return
            }
            OpenDotaController.loadRecentMatch(userid: "\(profile.id)", offSet: selectedRecentMatches.count, limit: 50) { recentMatches in
//                self.selectedRecentMatches.append(contentsOf: recentMatches)
//                if self.selectedGame == nil && !recentMatches.isEmpty {
//                    self.loadMatch(match: recentMatches.first!)
//                }
                DispatchQueue.main.async {
                    
                    self.loadingMatches = false
                }
            }
        }
    }
}
