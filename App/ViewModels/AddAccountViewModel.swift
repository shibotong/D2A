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
    }
    
    @MainActor
    func search(searchText: String) async {
        self.userProfiles = []
        self.filterHeroes = HeroDatabase.shared.fetchAllHeroes().filter { hero in
            hero.localizedName.lowercased().contains(searchText.lowercased())
        }
//        self.isLoading = true
        let searchedProfile = await OpenDotaController.shared.searchUserByText(text: searchText)
        self.userProfiles = searchedProfile
//        self.isLoading = false
    }
}
