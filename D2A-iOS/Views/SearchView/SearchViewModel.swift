//
//  AddAccountViewModel.swift
//  App
//
//  Created by Shibo Tong on 20/8/21.
//

import Combine
import Foundation

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

    @Published var searchHistory: [String] {
        didSet {
            UserDefaults.standard.set(searchHistory, forKey: "dotaArmory.searchHistory")
        }
    }
    
    private let allHeroes: [Hero]
    
    init(viewContext: D2AManagedObjectContext = PersistanceProvider.shared.mainContext) {
        let allHeroes = (try? viewContext.fetchAll(type: Hero.self)) ?? []
        self.allHeroes = allHeroes
        searchHistory =
            UserDefaults.standard.object(forKey: "dotaArmory.searchHistory") as? [String] ?? []

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
                guard !text.isEmpty else {
                    return []
                }
                let profiles = UserProfile.fetch(text: text, favourite: true)
                return profiles
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

    func addSearch(_ searchText: String) {
        guard !searchText.isEmpty, !searchHistory.contains(searchText) else {
            return
        }
        searchHistory.append(searchText)
        if searchHistory.count >= 15 {
            searchHistory.remove(at: 0)
        }
    }
}
