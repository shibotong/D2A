//
//  Provider.swift
//  App
//
//  Created by Shibo Tong on 19/9/21.
//

import WidgetKit
import SwiftUI
import Intents
//import App

struct Provider: IntentTimelineProvider {
    // Intent configuration of the widget
    typealias Intent = DynamicUserSelectionIntent
    
    public typealias Entry = SimpleEntry
    
    private let persistenceController = PersistenceController.shared
    
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), matches: [], user: nil, subscription: true)
    }

    func getSnapshot(for configuration: DynamicUserSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let user = user(for: configuration)
        let profile = persistenceController.fetchFirstWidgetUser()

        guard let profile, let userID = profile.id else {
            let entry = SimpleEntry(date: Date(), matches: [], user: user, subscription: true)
            completion(entry)
            return
        }
        
        // Use matches on device to load snapshot
        let matches = RecentMatch.fetch(userID: userID, count: 10)
        let entry = SimpleEntry(date: Date(), matches: matches, user: profile, subscription: true)
        completion(entry)
    }
    

    func getTimeline(for configuration: DynamicUserSelectionIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let currentDate = Date()
        let status = UserDefaults(suiteName: GROUP_NAME)?.object(forKey: "dotaArmory.subscription") as? Bool ?? false
        guard status, let selectedProfile = user(for: configuration) else {
            let entry = SimpleEntry(date: Date(), matches: [], user: nil, subscription: status)
            let timeline = Timeline(entries: [entry], policy: .never)
            completion(timeline)
            return
        }
        if let userID = selectedProfile.id {
            Task {
                let matches = await loadNewMatches(for: userID)
                let entry = SimpleEntry(date: Date(), matches: matches, user: selectedProfile, subscription: status)
                let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
            }
        } else {
            // no configuration
            let profile = persistenceController.fetchFirstWidgetUser()
            guard let profile, let userID = profile.id else {
                let entry = SimpleEntry(date: Date(), matches: [], user: selectedProfile, subscription: status)
                let refreshDate = Calendar.current.date(byAdding: .minute, value: 10, to: currentDate)!
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
                return
            }
            
            Task {
                let matches = await loadNewMatches(for: userID)
                let entry = SimpleEntry(date: Date(), matches: matches, user: profile, subscription: status)
                let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
                let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
                completion(timeline)
            }
        }
    }
    
    func user(for configuration: DynamicUserSelectionIntent) -> UserProfile? {
        guard let id = configuration.profile?.identifier, let profile = UserProfile.fetch(id: id) else {
            let fetchRequest = UserProfile.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "register = %d", true)
            let result = try? persistenceController.container.viewContext.fetch(fetchRequest)
            return result?.first
        }
        return profile
    }
    
    private func loadNewMatches(for userID: String) async -> [RecentMatch] {
        let existMatches = RecentMatch.fetch(userID: userID, count: 1)
        await OpenDotaController.shared.loadRecentMatch(userid: userID, lastMatch: existMatches.first)
        let newMatches = RecentMatch.fetch(userID: userID, count: 10)
        return newMatches
    }
}
