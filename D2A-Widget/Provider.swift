//
//  Provider.swift
//  App
//
//  Created by Shibo Tong on 19/9/21.
//

import Intents
import SwiftUI
import WidgetKit
import CoreData

struct Provider: IntentTimelineProvider {
    // Intent configuration of the widget
    typealias Intent = DynamicUserSelectionIntent

    public typealias Entry = D2AWidgetUserEntry

    private let openDotaProvider: OpenDotaProviding
    private let imageProvider: ImageProviding
    private let gameDataController: GameDataController
    private let persistanceProvider: PersistanceProviding
    
    private let userPlaceholder = D2AWidgetUserEntry(date: Date(), user: .preview, subscription: true)
    
    init(openDotaProvider: OpenDotaProviding = OpenDotaProvider.shared,
         persistanceProvider: PersistanceProviding = PersistanceProvider.shared,
         imageProvider: ImageProviding = ImageProvider.shared,
         gameDataController: GameDataController = .shared) {
        self.openDotaProvider = openDotaProvider
        self.imageProvider = imageProvider
        self.gameDataController = gameDataController
        self.persistanceProvider = persistanceProvider
    }

    func placeholder(in context: Context) -> D2AWidgetUserEntry {
        userPlaceholder
    }

    func getSnapshot(
        for configuration: DynamicUserSelectionIntent, in context: Context,
        completion: @escaping (D2AWidgetUserEntry) -> Void
    ) {
        let profile = firstWidgetUser()
        guard let profile, let userID = profile.id else {
            completion(userPlaceholder)
            return
        }
        // Use matches on device to load snapshot
        let matches = RecentMatch.fetch(userID: userID, count: 10, viewContext: persistanceProvider.mainContext)
        let userAvatar = imageProvider.localImage(type: .avatar, id: userID, fileExtension: .jpg)

        let user = D2AWidgetUser(profile, image: userAvatar, matches: matches)
        let entry = D2AWidgetUserEntry(date: Date(), user: user, subscription: true)
        completion(entry)
    }

    func getTimeline(
        for configuration: DynamicUserSelectionIntent, in context: Context,
        completion: @escaping (Timeline<D2AWidgetUserEntry>) -> Void
    ) {
        let currentDate = Date()
        let status =
            UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.subscription") as? Bool
            ?? false
        guard status, let selectedProfile = user(for: configuration),
            let userID = selectedProfile.id
        else {
            let entry = D2AWidgetUserEntry(date: Date(), user: nil, subscription: status)
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
            return
        }
        Task {
            let matches = await loadNewMatches(for: userID)
            var profile = selectedProfile
            if selectedProfile.shouldUpdate {
                profile = await refreshUser(for: userID) ?? selectedProfile
            }

            var image = imageProvider.localImage(type: .avatar, id: userID, fileExtension: .jpg)

            if let urlString = profile.avatarfull, image == nil,
               let newImage = await imageProvider.remoteImage(url: urlString) {
                image = newImage
                try? imageProvider.saveImage(image: newImage, type: .avatar, id: userID, fileExtension: .jpg)
            }

            let user = D2AWidgetUser(profile, image: image, matches: matches)
            let entry = D2AWidgetUserEntry(date: Date(), user: user, subscription: status)
            let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
    
    private func firstWidgetUser() -> UserProfile? {
        let fetchRequest = UserProfile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "favourite = %d", true)
        do {
            let result = try persistanceProvider.mainContext.fetch(fetchRequest)
            return result.first(where: { $0.register }) ?? result.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    private func user(for configuration: DynamicUserSelectionIntent) -> UserProfile? {
        guard let id = configuration.profile?.identifier, let profile = UserProfile.fetch(id: id) else {
            return firstWidgetUser()
        }

        return profile
    }

    private func loadNewMatches(for userID: String) async -> [RecentMatch] {
        await gameDataController.refreshRecentMatches(for: userID, viewContext: persistanceProvider.mainContext)
        let newMatches = gameDataController.fetchRecentMatches(for: userID, context: persistanceProvider.mainContext, count: 10)
        return newMatches
    }

    private func refreshUser(for userID: String) async -> UserProfile? {
        do {
            let user = try await openDotaProvider.user(id: userID)
            let newProfile = try user.update(context: persistanceProvider.mainContext) as? UserProfile
            return newProfile
        } catch {
            return nil
        }
    }
}
