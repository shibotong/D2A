//
//  HeroListViewModel.swift
//  App
//
//  Created by Shibo Tong on 9/6/2022.
//

import Foundation
import Combine

enum HeroAttribute: String, CaseIterable {
    case whole, str, agi, int, all
    
    var fullName: String {
        switch self {
        case .str:
            return "STRENGTH"
        case .agi:
            return "AGILITY"
        case .int:
            return "INTELLIGENCE"
        case .all:
            return "UNIVERSAL"
        default:
            return ""
        }
    }
}

class HeroListViewModel: ObservableObject {
    let heroList: [ODHero]
    
    @Published var searchResults: [ODHero]
    
    @Published var searchString: String = ""
    @Published var gridView = true
    @Published var selectedAttribute: HeroAttribute = .whole
    
    private var subscribers = Set<AnyCancellable>()
    
    init() {
        heroList = HeroDatabase.shared.fetchAllHeroes().sorted { $0.heroNameLocalized < $1.heroNameLocalized }
        searchString = ""
        searchResults = []
        selectedAttribute = .whole
        $searchString
            .combineLatest($selectedAttribute)
            .map { [weak self] searchString, attributes in
                guard let self = self else { return [] }
                let filterHeroes = attributes == .whole ? self.heroList : self.heroList.filter({ return $0.primaryAttr == attributes.rawValue })
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
            .sink { [weak self] results in
                self?.searchResults = results
            }
            .store(in: &subscribers)
    }
}
