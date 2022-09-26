//
//  HeroListViewModel.swift
//  App
//
//  Created by Shibo Tong on 9/6/2022.
//

import Foundation
import Combine

enum HeroAttributes: String {
    case all, str, agi, int
    
    var fullName: String {
        switch self {
        case .all:
            return "All"
        case .str:
            return "Strength"
        case .agi:
            return "Agility"
        case .int:
            return "Intelligence"
        }
    }
}

class HeroListViewModel: ObservableObject {
    let heroList: [Hero]
    
    @Published var searchResults: [Hero]
    
    @Published var searchString: String = ""
    @Published var gridView = true
    @Published var attributes: HeroAttributes = .all
    
    private var subscribers = Set<AnyCancellable>()
    
    init() {
        self.heroList = HeroDatabase.shared.fetchAllHeroes().sorted { $0.heroNameLocalized < $1.heroNameLocalized }
        self.searchString = ""
        self.searchResults = []
        self.attributes = .all
        $searchString
            .combineLatest($attributes)
            .map { searchString, attributes in
                let filterHeroes = attributes == .all ? self.heroList : self.heroList.filter({ return $0.primaryAttr == attributes.rawValue })
                if searchString.isEmpty {
                    return filterHeroes
                } else {
                    let searchedHeroes = filterHeroes.filter({ hero in
                        let originalName = hero.localizedName.lowercased().contains(searchString.lowercased())
                        let localizedName = hero.heroNameLocalized.lowercased().contains(searchString.lowercased())
                        return originalName || localizedName
                    })
                    return searchedHeroes
                }
            }
            .assign(to: \.searchResults, on: self)
            .store(in: &subscribers)
    }
}
