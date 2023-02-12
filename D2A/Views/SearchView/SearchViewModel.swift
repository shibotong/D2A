//
//  AddAccountViewModel.swift
//  App
//
//  Created by Shibo Tong on 20/8/21.
//

import Foundation
import Combine

class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searched = false
    
    @Published var searchedHeroes: [HeroCodable] = []
    @Published var searchedMatch: Match?
    @Published var filterHeroes: [HeroCodable] = []
    
    @Published var isLoading: Bool = false
    
    @Published var userProfiles: [UserProfileCodable] = []
    @Published var localProfiles: [UserProfile] = []
    
    private var cancellableObject: Set<AnyCancellable> = []
    init() {
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
                self?.searchedHeroes = searchResults
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
                self?.localProfiles = searchProfiles
            }
            .store(in: &cancellableObject)
    }
    
    func searchUserInData(searchText: String) {
        let profiles = UserProfile.fetch(text: searchText)
        localProfiles = profiles
    }
    
    @MainActor
    func search(searchText: String) async {
        isLoading = true
        userProfiles = []
        filterHeroes = HeroDatabase.shared.fetchAllHeroes().filter { hero in
            return hero.heroNameLocalized.lowercased().contains(searchText.lowercased())
        }
        async let searchedProfile = OpenDotaController.shared.searchUserByText(text: searchText)
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
        var notCachedProfiles: [UserProfileCodable] = []
        
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
        
        localProfiles = cachedProfiles
        userProfiles = notCachedProfiles
        
        isLoading = false
    }
}
