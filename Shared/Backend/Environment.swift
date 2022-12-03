//
//  Environment.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import SwiftUI
import UIKit

enum TabSelection {
    case home, hero, search, setting
}

final class DotaEnvironment: ObservableObject {
    static var shared = DotaEnvironment()
    static var preview: DotaEnvironment = {
        let env = DotaEnvironment()
        env.userIDs = ["125581247", "177416702", "153041957"]
        env.registerdID = "153041957"
        return env
    }()
    
    var refreshHandler: [String: TimeInterval] = [:]
    
    @Published var userIDs: [String] {
        didSet {
            UserDefaults(suiteName: GROUP_NAME)!.set(userIDs, forKey: "dotaArmory.userID")
        }
    }
    
    @Published var registerdID: String {
        didSet {
            UserDefaults(suiteName: GROUP_NAME)!.set(registerdID, forKey: "dotaArmory.registerdID")
        }
    }
    
    // MARK: Errors
    @Published var error = false
    @Published var errorMessage = ""
    
    @Published var subscriptionSheet = false
    
    @Published var subscriptionStatus: Bool {
        didSet {
            UserDefaults(suiteName: GROUP_NAME)!.set(subscriptionStatus, forKey: "dotaArmory.subscription")
        }
    }
    
    
    @Published var selectedTab: TabSelection = .home
    @Published var iPadSelectedTab: TabSelection? = .home
    
    @Published var selectedUser: String? = nil
    @Published var selectedMatch: String? = nil
    @Published var matchActive: Bool = false
    @Published var userActive: Bool = false

    init() {
        self.userIDs = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.userID") as? [String] ?? []
        self.subscriptionStatus = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.subscription") as? Bool ?? false
        self.registerdID = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.registerdID") as? String ?? ""
    }
    
    func move(from source: IndexSet, to destination: Int) {
        userIDs.move(fromOffsets: source, toOffset: destination)
    }
    func delete(from indexSet: IndexSet) {
        userIDs.remove(atOffsets: indexSet)
    }
    
    func delete(userID: String) {
        if let index = userIDs.firstIndex(of: userID) {
            self.userIDs.remove(at: index)
            UserProfile.delete(id: userID)
        }
    }
    
    func addOrDeleteUser(userid: String, profile: UserProfile? = nil) {
        if self.userIDs.contains(userid) {
            self.userIDs.remove(at: self.userIDs.firstIndex(of: userid)!)
            UserProfile.delete(id: userid)
        } else {
            if self.userIDs.count >= 1 && !self.subscriptionStatus {
                self.subscriptionSheet = true
            } else {
                self.userIDs.append(userid)
            }
        }
    }
    
    func registerUser(userid: String) async {
        guard let _ = await OpenDotaController.shared.loadUserData(userid: userid) else {
            print("cannot find this user please try again")
            await self.cannotFindUser()
            return
        }
        await self.setRegisterUser(userid: userid)
    }
    
    func deRegisterUser(userid: String) {
        UserProfile.delete(id: userid)
        self.registerdID = ""
    }
    
    @MainActor
    func setRegisterUser(userid: String) {
        self.delete(userID: userid)
        self.registerdID = userid
    }
    
    @MainActor
    func cannotFindUser() {
        self.error = true
        self.errorMessage = "Cannot Find User"
    }
    
    func canRefresh(userid: String) -> Bool {
        let currentTime = Date().timeIntervalSince1970
        guard let lastRefresh = refreshHandler[userid] else {
            self.refreshHandler[userid] = currentTime
            return true
        }
        
        let distance = currentTime - lastRefresh
        print("last refresh \(distance)s before")
        if distance > 60 {
            refreshHandler[userid] = currentTime
            return true
        } else {
            return false
        }
    }
    
    private func loadUser(userid: String) async {
        let profile = await OpenDotaController.shared.loadUserData(userid: userid)
        guard let profile = profile else {
            return
        }
        let _ = UserProfile.create(profile)
    }
}
