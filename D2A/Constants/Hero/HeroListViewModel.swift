//
//  HeroListViewModel.swift
//  App
//
//  Created by Shibo Tong on 9/6/2022.
//

import Foundation
import Combine
import CoreData

class HeroListViewModel: ObservableObject {
    
    @Published var searchResults: [any HeroProtocol]
    @Published var heroes: [any HeroProtocol]
    
    @Published var searchString: String = ""
    @Published var gridView = true
    @Published var selectedAttribute: HeroAttribute = .whole
    
    private var cancellable: AnyCancellable?
    private let logger: D2ALogger
    private let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext = PersistenceProvider.shared.mainContext,
         notification: D2ANotification = .default,
         logger: D2ALogger = .shared) {
        self.context = context
        self.logger = logger
        let fetchRequest = Hero.fetchRequest()
        var heroes: [any HeroProtocol] = []
        do {
            heroes = try context.fetch(fetchRequest).sorted { $0.localizedName < $1.localizedName }
        } catch {
            logger.error("Failed to fetch hero data \(error)", category: .sync)
        }
        self.heroes = heroes
        self.searchResults = heroes
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
