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
        self.heroList = HeroDatabase.shared.fetchAllHeroes()
        self.searchString = ""
        self.searchResults = []
        self.attributes = .all
        $searchString
            .combineLatest($attributes)
            .map { searchString, attributes in
                let filterHeroes = attributes == .all ? self.heroList.sorted { $0.id < $1.id } : self.heroList.filter({ return $0.primaryAttr == attributes.rawValue })
                if searchString.isEmpty {
                    return filterHeroes
                } else {
                    let searchedHeroes = filterHeroes.filter({return NSLocalizedString($0.localizedName, comment: "").lowercased().contains(searchString.lowercased())})
                    return searchedHeroes
                }
            }
            .assign(to: \.searchResults, on: self)
            .store(in: &subscribers)
    }
}
