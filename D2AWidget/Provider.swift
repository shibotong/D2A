//
//  Provider.swift
//  App
//
//  Created by Shibo Tong on 19/9/21.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    // Intent configuration of the widget
    typealias Intent = DynamicUserSelectionIntent
    
    public typealias Entry = D2AWidgetUserEntry
    
    private let persistanceController = PersistanceController.shared
    
    func placeholder(in context: Context) -> D2AWidgetUserEntry {
        D2AWidgetUserEntry(date: Date(), user: D2AWidgetUser.preview, subscription: true)
    }

    func getSnapshot(for configuration: DynamicUserSelectionIntent, in context: Context, completion: @escaping (D2AWidgetUserEntry) -> Void) {
        let profile = persistanceController.fetchFirstWidgetUser()
        
        guard let profile, let userID = profile.id else {
            let entry = D2AWidgetUserEntry(date: Date(), user: D2AWidgetUser.preview, subscription: true)
            completion(entry)
            return
        }
        
        // Use matches on device to load snapshot
        let matches = RecentMatch.fetch(userID: userID, count: 10)
        let userAvatar = ImageCache.readImage(type: .avatar, id: userID)
        
        let user = D2AWidgetUser(profile, image: userAvatar, matches: matches)
        let entry = D2AWidgetUserEntry(date: Date(), user: user, subscription: true)
        completion(entry)
    }

    func getTimeline(for configuration: DynamicUserSelectionIntent, in context: Context, completion: @escaping (Timeline<D2AWidgetUserEntry>) -> Void) {
        let currentDate = Date()
        let status = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.subscription") as? Bool ?? false
        guard status, let selectedProfile = user(for: configuration), let userID = selectedProfile.id else {
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
            
            var image = ImageCache.readImage(type: .avatar, id: userID)
            
            if let urlString = profile.avatarfull, image == nil,
               let newImage = await ImageCache.loadImage(urlString: urlString) {
                    image = newImage
                    ImageCache.saveImage(newImage, type: .avatar, id: userID)
            }
            
            let user = D2AWidgetUser(profile, image: image, matches: matches)
            let entry = D2AWidgetUserEntry(date: Date(), user: user, subscription: status)
            let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
    
    private func user(for configuration: DynamicUserSelectionIntent) -> UserProfile? {
        guard let id = configuration.profile?.identifier, let profile = UserProfile.fetch(id: id) else {
            return persistanceController.fetchFirstWidgetUser()
        }
        
        return profile
    }
    
    private func loadNewMatches(for userID: String) async -> [RecentMatch] {
        await OpenDotaController.shared.loadRecentMatch(userid: userID)
        let newMatches = RecentMatch.fetch(userID: userID, count: 10)
        return newMatches
    }
    
    private func refreshUser(for userID: String) async -> UserProfile? {
        do {
            let profileCodable = try await OpenDotaController.shared.loadUserData(userid: userID)
            _ = try UserProfile.create(profileCodable)
            let newProfile = UserProfile.fetch(id: userID)
            return newProfile
        } catch {
            return nil
        }
    }
}
