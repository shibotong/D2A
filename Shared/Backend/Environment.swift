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
    
    // migration loading
    @Published var loading = false
    
    // tab selections
    var tab: TabSelection {
        didSet {
            selectedTab = tab
            iPadSelectedTab = tab
        }
    }
    
    @Published var selectedTab: TabSelection = .home
    @Published var iPadSelectedTab: TabSelection? = .home
    
    @Published var selectedUser: String?
    @Published var selectedMatch: String?
    @Published var matchActive: Bool = false
    @Published var userActive: Bool = false
    
    @Published var percentage: Double = 0.0
    
    private let REMOVE_DUPLICATE_KEY = "dotaArmory.duplicateMatches2.2.1"

    init() {
        let userIDs = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.userID") as? [String] ?? []
        let registerdID = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.registerdID") as? String ?? ""
        subscriptionStatus = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.subscription") as? Bool ?? false
        tab = .home
        Task {
            DispatchQueue.main.async {
                self.loading = true
            }
            if !isTesting {
                // migrate from WCDB Database to CoreData
                if registerdID != "" || !userIDs.isEmpty {
                    await migration(registerID: registerdID, userIDs: userIDs)
                }
            }
            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }
    
    static func isInWidget() -> Bool {
        guard let extesion = Bundle.main.infoDictionary?["NSExtension"] as? [String: String] else { return false }
        guard let widget = extesion["NSExtensionPointIdentifier"] else { return false }
        return widget == "com.apple.widgetkit-extension"
    }
    
    /// Check if user can refresh this player (Debug mode 1s Release mode 60s)
    /// - parameters:
    /// - userid: Player ID
    /// - Returns: Returns a `Bool` value of if user can refresh this player
    func canRefresh(userid: String) -> Bool {
        let currentTime = Date().timeIntervalSince1970
        guard let lastRefresh = refreshHandler[userid] else {
            refreshHandler[userid] = currentTime
            return true
        }
        
        let distance = currentTime - lastRefresh
        if distance > refreshDistance {
            refreshHandler[userid] = currentTime
            return true
        } else {
            print("last refresh \(distance)s before, cannot refresh")
            return false
        }
    }
    
    private func migration(registerID: String, userIDs: [String]) async {
        print("Migrating")
        if let userCodable = try? await OpenDotaController.shared.loadUserData(userid: registerID) {
            try? UserProfile.create(userCodable, favourite: true, register: true)
        }
        for userID in userIDs {
            if let userCodable = try? await OpenDotaController.shared.loadUserData(userid: userID) {
                try? UserProfile.create(userCodable, favourite: true, register: false)
            }
        }
        UserDefaults(suiteName: GROUP_NAME)?.set("", forKey: "dotaArmory.registerdID")
        UserDefaults(suiteName: GROUP_NAME)?.set([String](), forKey: "dotaArmory.userID")
    }
    
    private func removeNotFavouriteRecentMatches() {
        let moc = PersistenceController.shared.makeContext()
        let fetchRequest = UserProfile.fetchRequest()
        let notFavouritePredicate = NSPredicate(format: "favourite = %d", false)
        fetchRequest.predicate = notFavouritePredicate
        guard let players = try? moc.fetch(fetchRequest) else {
            return
        }
        players.forEach { player in
            guard let playerID = player.id else { return }
            PersistenceController.shared.deleteRecentMatchesForUserID(userID: playerID)
        }
    }
    
    @MainActor
    private func setPercent(_ percentage: Double) {
        self.percentage = percentage
    }
}
