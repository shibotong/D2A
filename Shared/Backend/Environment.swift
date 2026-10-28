//
//  Environment.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import SwiftUI
import UIKit

enum TabSelection: Hashable {
    case home
    case hero
    case search
    case setting
    case user(String)
}

final class DotaEnvironment: ObservableObject {
    static var shared = DotaEnvironment()
    
    // MARK: Errors
    @Published var error = false
    @Published var errorMessage = ""
    
    @Published var subscriptionSheet = false
    
    @Published var subscriptionStatus: Bool
    
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
    
    let imageProvider: ImageProviding
    
    private let notification: D2ANotification
    private let userDefaults: UserDefaults?

    init(imageProvider: ImageProviding = ImageProvider.shared,
         userDefaults: UserDefaults? = .shared,
         notification: D2ANotification = .default) {
        self.notification = notification
        subscriptionStatus = userDefaults?.bool(forKey: .purchaseKey) ?? false
        self.userDefaults = userDefaults
        tab = .home
        let lastVersion = userDefaults?.string(forKey: "dotaArmory.appVersion")
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        self.imageProvider = imageProvider
        if appVersion != lastVersion {
            versionUpdate(lastVersion: lastVersion, currentVersion: appVersion)
            userDefaults?.setValue(appVersion, forKey: "dotaArmory.appVersion")
        }
        setupBinding()
    }
    
    private func setupBinding() {
        notification.purchaseCompletion
            .receive(on: DispatchQueue.main)
            .assign(to: &$subscriptionStatus)
    }
    
    static func isInWidget() -> Bool {
        guard let extesion = Bundle.main.infoDictionary?["NSExtension"] as? [String: String] else { return false }
        guard let widget = extesion["NSExtensionPointIdentifier"] else { return false }
        return widget == "com.apple.widgetkit-extension"
    }
    
    private func removeNotFavouriteRecentMatches() {
        let moc = PersistenceProvider.shared.makeContext()
        let fetchRequest = UserProfile.fetchRequest()
        let notFavouritePredicate = NSPredicate(format: "favourite = %d", false)
        fetchRequest.predicate = notFavouritePredicate
        guard let players = try? moc.fetch(fetchRequest) else {
            return
        }
        players.forEach { player in
            guard let playerID = player.userId else { return }
            PersistenceProvider.shared.deleteRecentMatchesForUserID(userID: playerID)
        }
    }
    
    private func versionUpdate(lastVersion: String?, currentVersion: String?) {
        
    }
}
