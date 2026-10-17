//
//  AddAccountViewModel.swift
//  App
//
//  Created by Shibo Tong on 20/8/21.
//

import Foundation
import Combine
import OpenDota

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    
    // suggestion
    @Published var suggestHeroes: [HeroCodable] = []
    @Published var suggestLocalProfiles: [UserProfile] = []
    
    // search results
    @Published var userProfiles: [ODSearchPlayer] = []
    @Published var searchLocalProfiles: [UserProfile] = []
    @Published var searchedMatch: Match?
    @Published var filterHeroes: [HeroCodable] = []
    
    @Published var searchHistory: [String] {
        didSet {
            UserDefaults.standard.set(searchHistory, forKey: "dotaArmory.searchHistory")
        }
    }
    
    private var cancellableObject: Set<AnyCancellable> = []
    
    private let openDotaFetcher: OpenDotaFetching
    
    init(openDotaFetcher: OpenDotaFetching = OpenDotaFetcher.shared) {
        self.openDotaFetcher = openDotaFetcher
        searchHistory = UserDefaults.standard.object(forKey: "dotaArmory.searchHistory") as? [String] ?? []
        
        $searchText
            .receive(on: RunLoop.main)
            .map { text in
                if !text.isEmpty {
                    let heroes = HeroDatabase.shared.fetchAllHeroes().filter({
                        return $0.heroNameLocalized.lowercased().contains(text.lowercased())
                    })
                    return heroes
                } else {
                    return []
                }
            }
            .sink { [weak self] searchResults in
                self?.suggestHeroes = searchResults
            }
            .store(in: &cancellableObject)
        $searchText
            .receive(on: RunLoop.main)
            .map { text in
                if !text.isEmpty {
                    let profiles = UserProfile.fetch(text: text, favourite: true)
                    return profiles
                } else {
                    return []
                }
            }
            .sink { [weak self] searchProfiles in
                self?.suggestLocalProfiles = searchProfiles
            }
            .store(in: &cancellableObject)
    }
    
    func search(searchText: String) async {
        isLoading = true
        // set suggestion to empty
        suggestLocalProfiles = []
        suggestHeroes = []
        
        userProfiles = []
        filterHeroes = HeroDatabase.shared.fetchAllHeroes().filter { hero in
            return hero.heroNameLocalized.lowercased().contains(searchText.lowercased())
        }
        async let searchedProfile = openDotaFetcher.search(personaname: searchText)
        let searchCachedProfile = UserProfile.fetch(text: searchText)
        if Int(searchText) != nil {
            async let matchID = OpenDotaController.shared.loadMatchData(matchid: searchText)
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
        var notCachedProfiles: [ODSearchPlayer] = []
        
        do {
            for profile in try await searchedProfile {
                if let cachedProfile = UserProfile.fetch(id: "\(profile.accountId)") {
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
        } catch {
            print("Failed to load search profile \(error)")
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
