//
//  SearchSuggestionViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 16/8/2025.
//

import Foundation

class SearchSuggestionViewModel: ObservableObject {
    @Published var searchHistory: [String]
    
    private let userDefaults: UserDefaults?
    
    convenience init(userDefaults: UserDefaults = .standard) {
        let searchHistory = userDefaults.object(for: .searchHistory) as? [String] ?? []
        self.init(searchHistory: searchHistory, userDefaults: userDefaults)
    }
    
    init(searchHistory: [String], userDefaults: UserDefaults? = nil) {
        self.searchHistory = searchHistory
        self.userDefaults = userDefaults
    }
}
