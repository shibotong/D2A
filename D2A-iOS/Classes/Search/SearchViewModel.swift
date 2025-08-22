//
//  AddAccountViewModel.swift
//  App
//
//  Created by Shibo Tong on 20/8/21.
//

import Combine
import Foundation
import CoreData

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false

    // suggestion
    @Published var suggestHeroes: [Hero] = []
    @Published var suggestLocalProfiles: [UserProfile] = []

    // search results
    @Published var userProfiles: [ODUserProfile] = []
    @Published var searchLocalProfiles: [UserProfile] = []
    @Published var searchedMatch: Match?
    @Published var filterHeroes: [Hero] = []
    
    private let allHeroes: [Hero]
    private let viewContext: NSManagedObjectContext
    
    init(viewContext: D2AManagedObjectContext = PersistanceProvider.shared.mainContext) {
        self.viewContext = viewContext
        let allHeroes = (try? viewContext.fetchAll(type: Hero.self)) ?? []
        self.allHeroes = allHeroes

        $searchText
            .receive(on: RunLoop.main)
            .map { text in
                guard !text.isEmpty else {
                    return []
                }
                let heroes = allHeroes.filter({
                    return $0.heroNameLocalized.lowercased().contains(text.lowercased())
                })
                return heroes
            }
            .assign(to: &$suggestHeroes)

        $searchText
            .receive(on: RunLoop.main)
            .map { text in
//                guard !text.isEmpty else {
                    return []
//                }
//                let profiles = UserProfile.fetch(text: text, favourite: true)
//                return profiles
            }
            .assign(to: &$suggestLocalProfiles)
    }

    @MainActor
    func search(searchText: String) async {
        isLoading = true
        // set suggestion to empty
        suggestLocalProfiles = []
        suggestHeroes = []

        userProfiles = []
        filterHeroes = allHeroes.filter { hero in
            return hero.heroNameLocalized.lowercased().contains(searchText.lowercased())
        }
        async let searchedProfile = OpenDotaProvider.shared.searchUserByText(text: searchText)
        let searchCachedProfile = UserProfile.fetch(text: searchText)
        if Int(searchText) != nil {
            async let matchID = OpenDotaProvider.shared.loadMatchData(matchid: searchText)
            do {
                searchedMatch = try await Match.fetch(id: matchID)
            } catch {
                print("parse match error")
                searchedMatch = nil
            }
        } else {
            searchedMatch = nil
        }

        var cachedProfiles: [UserProfile] = searchCachedProfile
        var notCachedProfiles: [ODUserProfile] = []

        for profile in await searchedProfile {
            if let cachedProfile = UserProfile.fetch(id: profile.id.description) {
                if cachedProfiles.contains(where: { profile in
                    profile.id == cachedProfile.id
                }) {
                    continue
                }
                cachedProfiles.append(cachedProfile)
            } else {
                notCachedProfiles.append(profile)
            }
        }

        searchLocalProfiles = cachedProfiles
        userProfiles = notCachedProfiles

        isLoading = false
    }

    func addSearch(user: UserProfile? = nil, hero: Hero? = nil, match: Match? = nil) {
        let searchHistory = SearchHistory(context: viewContext)
        searchHistory.searchTime = Date()
        if let user {
            searchHistory.player = user
        } else if let hero {
            searchHistory.hero = hero
        } else if let match {
            searchHistory.match = match
        } else {
            logError("No data for search history", category: .coredata)
            return
        }
        
        viewContext.insert(searchHistory)
        do {
            try viewContext.save()
        } catch {
            logError("An error occurred when saving search history: \(error)", category: .coredata)
        }
    }
}
