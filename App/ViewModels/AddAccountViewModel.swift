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
    @Published var userProfiles: [UserProfile] = []
    @Published var searchedHeroes: [Hero] = []
    @Published var searchedMatch: Match? = nil
    @Published var filterHeroes: [Hero] = []
    
    @Published var isLoading: Bool = false
    @Published var localProfiles: [UserProfile] = []
    
    
    private var cancellableObject: Set<AnyCancellable> = []
    init() {
        $searchText
            .receive(on: RunLoop.main)
            .map { text in
                if !text.isEmpty {
                    let heroes = HeroDatabase.shared.fetchAllHeroes().filter { hero in
                        hero.localizedName.lowercased().contains(text.lowercased()) && hero.localizedName.lowercased() != text.lowercased()
                    }
                    return heroes
                } else {
                    return []
                }
            }
            .assign(to: \.searchedHeroes, on: self)
            .store(in: &cancellableObject)
        $searchText
            .receive(on: RunLoop.main)
            .map { text in
                if !text.isEmpty {
                    let profiles = WCDBController.shared.fetchUserProfile(userName: text)
                    return profiles
                } else {
                    return []
                }
            }
            .assign(to: \.localProfiles, on: self)
            .store(in: &cancellableObject)
    }
    
    func searchUserInData(searchText: String) {
        let profiles = WCDBController.shared.fetchUserProfile(userName: searchText)
        self.localProfiles = profiles
    }
    
    @MainActor
    func search(searchText: String) async {
        self.userProfiles = []
        self.filterHeroes = HeroDatabase.shared.fetchAllHeroes().filter { hero in
            hero.localizedName.lowercased().contains(searchText.lowercased())
        }
        async let searchedProfile = OpenDotaController.shared.searchUserByText(text: searchText)
        if Int(searchText) != nil {
            async let searchedMatch = OpenDotaController.shared.loadMatchData(matchid: searchText)
            do {
                self.searchedMatch = try await searchedMatch
            } catch {
                print("parse match error")
            }
        }
        
        self.userProfiles = await searchedProfile
    }
}
