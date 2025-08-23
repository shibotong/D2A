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

final class EnvironmentController: ObservableObject {
    static var shared = EnvironmentController()

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

    private let imageProvider: ImageProviding
    private let imageCache: ImageCache
    
    private let userDefaults: UserDefaults
    
    private var refreshDistance: TimeInterval {
        var refreshTime: TimeInterval = 60
        #if DEBUG
            refreshTime = 1
        #endif
        return refreshTime
    }

    init(imageProvider: ImageProviding = ImageProvider.shared,
         imageCache: ImageCache = .shared,
         userDefaults: UserDefaults = .group) {
        self.imageProvider = imageProvider
        self.imageCache = imageCache
        self.userDefaults = userDefaults
        subscriptionStatus =
            UserDefaults(suiteName: GROUP_NAME)?.object(forKey: UserDefaults.subscription) as? Bool
            ?? false
        tab = .home
    }

    static func isInWidget() -> Bool {
        guard let extesion = Bundle.main.infoDictionary?["NSExtension"] as? [String: String] else {
            return false
        }
        guard let widget = extesion["NSExtensionPointIdentifier"] else { return false }
        return widget == "com.apple.widgetkit-extension"
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
            PersistanceProvider.shared.deleteRecentMatchesForUserID(userID: player.userID.description)
        }
    }
    
    func refreshImage(type: GameImageType, id: String, fileExtension: ImageExtension = .jpg,
                      url: String, refreshTime: Date = Date(),
                      imageHandler: (UIImage) -> Void) async throws {
        let imageKey = "\(type.imageKey)_\(id)"
        // Check cached image, if have cached image return it
        if let cachedImage = await imageCache.readCache(key: imageKey) {
            imageHandler(cachedImage)
            return
        }
        
        if let localImage = imageProvider.localImage(type: type, id: id, fileExtension: fileExtension) {
            await imageCache.setCache(key: imageKey, image: localImage)
            imageHandler(localImage)
        }
        
        if let savedDate = userDefaults.object(forKey: imageKey) as? Date, !Refresher.canRefreshImage(lastDate: savedDate, currentDate: refreshTime) {
            return
        }
        guard let remoteImage = await imageProvider.remoteImage(url: url) else {
            return
        }
        try imageProvider.saveImage(image: remoteImage, type: type, id: id, fileExtension: fileExtension)
        userDefaults.set(Date(), forKey: imageKey)
        await imageCache.setCache(key: imageKey, image: remoteImage)
        imageHandler(remoteImage)
    }
}
