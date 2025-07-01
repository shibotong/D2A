//
//  HeroListViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 1/7/2025.
//

import Foundation

extension HeroListView {
    class ViewModel: ObservableObject {
        
        @Published var selectedAttribute: AttributeSelection = .all
        @Published var searchString = ""
        @Published var searchedResults: [Hero] = []
        
        let heroes: [Hero]
        
        init(heroes: [Hero]) {
            self.heroes = heroes
            searchedResults = filterHero(searchText: searchString, selectedAttribute: selectedAttribute)
            setupBinding()
        }
        
        private func setupBinding() {
            $searchString
                .combineLatest($selectedAttribute)
                .map { [weak self] searchString, selectedAttribute in
                    guard let self else {
                        return []
                    }
                    return self.filterHero(searchText: searchString, selectedAttribute: selectedAttribute)
                }
                .assign(to: &$searchedResults)
        }
        
        private func filterHero(searchText: String, selectedAttribute: AttributeSelection) -> [Hero] {
            var searchedHeroes = heroes
            searchedHeroes = searchedHeroes.filter { hero in
                selectedAttribute.attributes.map { $0.rawValue }.contains(hero.primaryAttr)
            }
            if !searchText.isEmpty {
                searchedHeroes = searchedHeroes.filter({ $0.heroNameLocalized.lowercased().contains(searchText.lowercased()) })
            }
            return searchedHeroes
        }
    }
}
