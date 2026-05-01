//
//  HeroListViewModel.swift
//  App
//
//  Created by Shibo Tong on 9/6/2022.
//

import Foundation
import Combine
import CoreData
import Logging

class HeroListViewModel: ObservableObject {
    
    @Published var searchResults: [any HeroProtocol]
    @Published var heroes: [any HeroProtocol]
    
    @Published var searchString: String = ""
    @Published var gridView = true
    @Published var selectedAttribute: HeroAttribute = .whole
    
    private var cancellable: AnyCancellable?
    private let logger: Logger
    
    init(heroes: [Hero],
         notification: D2ANotification = .default,
         logger: Logger = D2ALogger.ui) {
        let sortedHeroes = heroes.sorted { $0.localizedName < $1.localizedName }
        self.heroes = sortedHeroes
        self.searchResults = sortedHeroes
        self.logger = logger
        setupBinding()
    }
    
    private func setupBinding() {
        cancellable = $searchString
            .combineLatest($selectedAttribute)
            .map { [weak self] searchString, attributes in
                guard let self = self else { return [] }
                let filterHeroes = attributes == .whole ? self.heroes : self.heroes.filter({ return $0.primaryAttribute == attributes.rawValue })
                if searchString.isEmpty {
                    return filterHeroes
                } else {
                    let searchedHeroes = filterHeroes.filter({ hero in
                        let localizedName = hero.localizedName.lowercased().contains(searchString.lowercased())
                        return localizedName
                    })
                    return searchedHeroes
                }
            }
            .sink { [weak self] results in
                self?.searchResults = results
            }
    }
}
