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
    case home, hero, search, setting, live
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
            UserDefaults.group.set(subscriptionStatus, forKey: UserDefaults.subscription)
        }
    }
    
    // migration loading
    @Published var loading = false
    
    // tab selections
    var tab: TabSelection {
        didSet {
            selectedTab = tab
        }
    }
    
    @Published var selectedTab: TabSelection = .home
    
    @Published var selectedUser: String?
    @Published var selectedMatch: String?
    @Published var matchActive: Bool = false
    @Published var userActive: Bool = false
    
    private var refreshDistance: TimeInterval {
        var refreshTime: TimeInterval = 60
        #if DEBUG
        refreshTime = 1
        #endif
        return refreshTime
    }

    init() {
        subscriptionStatus = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: UserDefaults.subscription) as? Bool ?? false
        tab = .home
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
    
    private func removeNotFavouriteRecentMatches() {
        let moc = PersistanceProvider.shared.makeContext()
        let fetchRequest = UserProfile.fetchRequest()
        let notFavouritePredicate = NSPredicate(format: "favourite = %d", false)
        fetchRequest.predicate = notFavouritePredicate
        guard let players = try? moc.fetch(fetchRequest) else {
            return
        }
        players.forEach { player in
            guard let playerID = player.id else { return }
            PersistanceProvider.shared.deleteRecentMatchesForUserID(userID: playerID)
        }
    }
}
