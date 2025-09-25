//
//  Environment.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import CoreData
import SwiftUI
import UIKit
import Combine

enum TabSelection {
    case home, hero, search, setting, live
}

final class EnvironmentController: ObservableObject {
    static var shared = EnvironmentController()

    // MARK: Errors
    @Published var error = false
    @Published var errorMessage = ""

    @Published var subscriptionSheet = false

    // migration loading
    @Published var loading = false

    // tab selections
    var tab: TabSelection {
        didSet {
            selectedTab = tab
        }
    }

    @Published var selectedTab: TabSelection = .home
    @Published var subscriptionStatus: Bool = false
    @Published var selectedUser: String?
    @Published var selectedMatch: String?
    @Published var matchActive: Bool = false
    @Published var userActive: Bool = false

    private let imageProvider: ImageProviding
    private let imageCache: ImageCache
    private let refreshHandler: RefreshHandler
    private let openDotaProvider: OpenDotaProviding
    
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
         userDefaults: UserDefaults = .group,
         openDotaProvider: OpenDotaProviding = OpenDotaProvider.shared,
         refreshHandler: RefreshHandler = .shared) {
        self.imageProvider = imageProvider
        self.imageCache = imageCache
        self.userDefaults = userDefaults
        self.openDotaProvider = openDotaProvider
        self.refreshHandler = refreshHandler
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
    
    @MainActor
    func refreshUser(userID: Int, context: NSManagedObjectContext, completionHandler: (UserProfile) -> Void) async {
        let userPredicate = UserProfile.predicate(for: userID)
        do {
            let existUser = try context.fetchOne(type: UserProfile.self, predicate: userPredicate)
            if let existUser {
                completionHandler(existUser)
            }
            if await refreshHandler.canRefresh(for: userID) {
                let remoteUser = try await openDotaProvider.user(id: "\(userID)")
                let user = existUser ?? UserProfile(context: context)
                user.update(with: remoteUser)
                if user.hasChanges {
                    try context.save()
                    completionHandler(user)
                }
            }
        } catch {
            logError("An error occurred when fetching user: \(error.localizedDescription)", category: .opendota)
        }
    }
    
    func canFavourite(context: NSManagedObjectContext) -> Bool {
        if subscriptionStatus {
            return true
        }
        let fetchResult: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        let favouritePredicate = NSPredicate(format: "favourite = %d", true)
        fetchResult.predicate = favouritePredicate
        do {
            let result = try context.count(for: fetchResult)
            return result < 1
        } catch {
            logError("Not able to count favourite users.", category: .coredata)
            return false
        }
    }
}

