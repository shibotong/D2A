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
    
    var refreshHandler: [String: TimeInterval] = [:]
    
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
        let userIDs = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.userID") as? [String] ?? []
        let registerdID = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.registerdID") as? String ?? ""
        subscriptionStatus = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.subscription") as? Bool ?? false
        
        // migrate from WCDB Database to CoreData
        if registerdID != "" || !userIDs.isEmpty {
            Task {
                await migration(registerID: registerdID, userIDs: userIDs)
            }
        }
    }
    
    private func migration(registerID: String, userIDs: [String]) async {
        if let userCodable = try? await OpenDotaController.shared.loadUserData(userid: registerID) {
            _ = try? UserProfile.create(userCodable, favourite: true, register: true)
        }
        for userID in userIDs {
            if let userCodable = try? await OpenDotaController.shared.loadUserData(userid: userID) {
                _ = try? UserProfile.create(userCodable, favourite: true, register: false)
            }
        }
        UserDefaults(suiteName: GROUP_NAME)?.set("", forKey: "dotaArmory.registerdID")
        UserDefaults(suiteName: GROUP_NAME)?.set([], forKey: "dotaArmory.userID")
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
}
