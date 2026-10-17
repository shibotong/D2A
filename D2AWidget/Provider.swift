//
//  Provider.swift
//  App
//
//  Created by Shibo Tong on 19/9/21.
//

import WidgetKit
import SwiftUI
import Intents
import OpenDota
import CoreData

struct Provider: IntentTimelineProvider {
    // Intent configuration of the widget
    typealias Intent = DynamicUserSelectionIntent
    
    public typealias Entry = D2AWidgetUserEntry
    
    private let persistenceController = PersistenceProvider.shared
    private let imageProvider: ImageProviding
    private let fetcher: GameDataFetcher
    private let viewContext: NSManagedObjectContext
    
    init(imageProvider: ImageProviding = ImageProvider.shared,
         fetcher: GameDataFetcher = OpenDotaFetcher.shared,
         context: NSManagedObjectContext = PersistenceProvider.shared.mainContext) {
        self.imageProvider = imageProvider
        self.fetcher = fetcher
        self.viewContext = context
    }
    
    func placeholder(in context: Context) -> D2AWidgetUserEntry {
        D2AWidgetUserEntry(date: Date(), user: D2AWidgetUser.preview, subscription: true)
    }

    func getSnapshot(for configuration: DynamicUserSelectionIntent, in context: Context, completion: @escaping (D2AWidgetUserEntry) -> Void) {
        let profile = fetchFirstWidgetUser()
        
        guard let profile, let userID = profile.id else {
            let entry = D2AWidgetUserEntry(date: Date(), user: D2AWidgetUser.preview, subscription: true)
            completion(entry)
            return
        }
        
        // Use matches on device to load snapshot
        let matches = RecentMatch.fetch(userID: userID, count: 10)
        let userAvatar = imageProvider.read(type: .avatar, id: userID)
        
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
            if selectedProfile.shouldUpdate {
                do {
                    let dto = try await fetcher.fetchUser(userID: userID)
                    selectedProfile.map(dto)
                    try viewContext.save()
                } catch {
                    
                }
            }
            
            var image = imageProvider.read(type: .avatar, id: userID)
            
            if let urlString = selectedProfile.avatarfull, image == nil,
               let newImage = await imageProvider.load(urlString: urlString) {
                    image = newImage
                imageProvider.save(newImage, type: .avatar, id: userID)
            }
            
            let user = D2AWidgetUser(selectedProfile, image: image, matches: matches)
            let entry = D2AWidgetUserEntry(date: Date(), user: user, subscription: status)
            let refreshDate = Calendar.current.date(byAdding: .minute, value: 30, to: currentDate)!
            let timeline = Timeline(entries: [entry], policy: .after(refreshDate))
            completion(timeline)
        }
    }
    
    private func user(for configuration: DynamicUserSelectionIntent) -> UserProfile? {
        guard let id = configuration.profile?.identifier, let profile = UserProfile.fetch(id: id, viewContext: viewContext) else {
            return fetchFirstWidgetUser()
        }
        
        return profile
    }
    
    private func loadNewMatches(for userID: String) async -> [RecentMatch] {
        await OpenDotaController.shared.loadRecentMatch(userid: userID)
        let newMatches = RecentMatch.fetch(userID: userID, count: 10)
        return newMatches
    }
    
    private func fetchFirstWidgetUser() -> UserProfile? {
        let fetchRequest = UserProfile.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "favourite = %d", true)
        do {
            let result = try viewContext.fetch(fetchRequest)
            return result.first(where: { $0.register }) ?? result.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
