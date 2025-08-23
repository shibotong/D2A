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
    @Published var heroes: [Hero] = []
    @Published var localProfiles: [UserProfile] = []
    @Published var remoteProfiles: [ODSearchProfile] = []
    @Published var searchedMatch: Match?
    
    private let viewContext: NSManagedObjectContext
    private let openDotaProvider: OpenDotaProviding
    private var cancellable: AnyCancellable?
    
    var showHistory: Bool {
        return searchText.isEmpty
    }
    
    var hasResults: Bool {
        return !heroes.isEmpty || !localProfiles.isEmpty || !remoteProfiles.isEmpty || searchedMatch != nil
    }
    
    init(viewContext: D2AManagedObjectContext = PersistanceProvider.shared.mainContext,
         openDotaProvider: OpenDotaProviding = OpenDotaProvider.shared) {
        self.viewContext = viewContext
        self.openDotaProvider = openDotaProvider
        cancellable = $searchText
            .sink { [weak self] text in
                self?.heroes = self?.searchHero(text: text) ?? []
                self?.localProfiles = self?.searchUser(text: text) ?? []
                self?.remoteProfiles = []
                self?.searchedMatch = nil
            }
    }
    
    private func searchHero(text: String) -> [Hero] {
        guard !text.isEmpty else {
            return []
        }
        do {
            let allHeroes = try viewContext.fetchAll(type: Hero.self)
            return allHeroes.filter { $0.heroNameLocalized.lowercased().contains(text.lowercased()) }
        } catch {
            logError("Not able to search hero. \(error.localizedDescription)", category: .coredata)
            return []
        }
    }
    
    private func searchUser(text: String) -> [UserProfile] {
        guard !text.isEmpty else {
            return []
        }
        do {
            let predicate = NSPredicate(format: "personaname CONTAINS[cd] %@", text)
            let users = try viewContext.fetchAll(type: UserProfile.self, predicate: predicate)
            return users
        } catch {
            logError("Not able to search local user. \(error.localizedDescription)", category: .coredata)
            return []
        }
    }

    @MainActor
    func search(searchText: String) async {
        isLoading = true
        // set suggestion to empty
        remoteProfiles = []
        async let searchedProfile = openDotaProvider.searchUserByText(text: searchText)
        if Int(searchText) != nil {
            async let matchID = openDotaProvider.loadMatchData(matchid: searchText)
            do {
                searchedMatch = try await Match.fetch(id: matchID)
            } catch {
                print("parse match error")
                searchedMatch = nil
            }
        } else {
            searchedMatch = nil
        }

        let cachedProfiles: [UserProfile] = localProfiles
        var notCachedProfiles: [ODSearchProfile] = []

        for profile in await searchedProfile {
            if !cachedProfiles.contains(where: { $0.id == profile.accountID.description }) {
                notCachedProfiles.append(profile)
            }
        }

        remoteProfiles = notCachedProfiles
        isLoading = false
    }

//    func addSearch(user: UserProfile? = nil, hero: Hero? = nil, match: Match? = nil) {
//        let searchHistory = SearchHistory(context: viewContext)
//        searchHistory.searchTime = Date()
//        if let user {
//            searchHistory.player = user
//        } else if let hero {
//            searchHistory.hero = hero
//        } else if let match {
//            searchHistory.match = match
//        } else {
//            logError("No data for search history", category: .coredata)
//            return
//        }
//        
//        viewContext.insert(searchHistory)
//        do {
//            try viewContext.save()
//        } catch {
//            logError("An error occurred when saving search history: \(error)", category: .coredata)
//        }
//    }
}
