//
//  AddAccountViewModel.swift
//  App
//
//  Created by Shibo Tong on 20/8/21.
//

import Foundation
import Combine

class AddAccountViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var searched = false
    @Published var userProfiles: [UserProfileCodable] = []
    @Published var searchedHeroes: [HeroCodable] = []
    @Published var searchedMatch: Match? = nil
    @Published var filterHeroes: [HeroCodable] = []
    
    @Published var isLoading: Bool = false
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
                    let profiles = UserProfile.fetch(text: text)
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
        if Int(searchText) != nil {
            async let searchedMatchResult = OpenDotaController.shared.loadMatchData(matchid: searchText)
            do {
                searchedMatch = try await searchedMatchResult
            } catch {
                print("parse match error")
                searchedMatch = nil
            }
        } else {
            searchedMatch = nil
        }
        
        userProfiles = await searchedProfile
        isLoading = false
    }
}
