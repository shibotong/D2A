//
//  HeroListViewModel.swift
//  App
//
//  Created by Shibo Tong on 9/6/2022.
//

import Foundation
import CoreData
import Combine

class HeroListViewModel: ObservableObject {
    let heroes: [Hero]
    
    @Published var filteredHeroes: [Hero]
    
    @Published var searchString: String = ""
    @Published var isGridView = true
    @Published var selectedAttribute: HeroAttribute = .whole
    
    init(heroes: [Hero]) {
        self.heroes = heroes
        filteredHeroes = heroes
        setupBinding()
    }
    
    private func setupBinding() {
        $searchString
            .combineLatest($selectedAttribute)
            .map { [weak self] searchString, attributes in
                guard let self = self else { return [] }
                let filterHeroes = attributes == .whole ? self.heroes : self.heroes.filter({ return $0.primaryAttr == attributes.rawValue })
                if searchString.isEmpty {
                    return filterHeroes
                } else {
                    let searchedHeroes = filterHeroes.filter({ hero in
                        let originalName = hero.displayName?.lowercased().contains(searchString.lowercased()) ?? false
                        let localizedName = hero.heroNameLocalized.lowercased().contains(searchString.lowercased())
                        return originalName || localizedName
                    })
                    return searchedHeroes
                }
            }
            .assign(to: &$filteredHeroes)
    }
}
