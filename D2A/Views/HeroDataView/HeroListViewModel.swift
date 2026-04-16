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
    
    @Published var searchResults: [HeroData]
    @Published var heroes: [HeroData]
    
    @Published var searchString: String = ""
    @Published var gridView = true
    @Published var selectedAttribute: HeroAttribute = .whole
    
    private var subscribers = Set<AnyCancellable>()
    private let context: NSManagedObjectContext
    private let language: DataLanguageEnum
    private let logger: Logger
    private let persistence: PersistenceProviding
    private let notification: D2ANotification
    
    init(persistence: PersistenceProviding = PersistenceProvider.shared,
         language: DataLanguageEnum = AppConfig.languageCode,
         notification: D2ANotification = .default,
         logger: Logger = D2ALogger.ui) {
        self.context = persistence.mainContext
        self.persistence = persistence
        self.language = language
        self.logger = logger
        self.notification = notification
        heroes = []
        searchString = ""
        searchResults = []
        selectedAttribute = .whole
        fetchData()
        setupBinding()
    }
    
    private func setupBinding() {
        notification.syncingCompletion
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.fetchData()
            }
            .store(in: &subscribers)
        $searchString
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
            .store(in: &subscribers)
    }
    
    private func fetchData() {
        var heroData: [HeroData] = []
        let heroes = fetchHeroes()
        for hero in heroes {
            guard let localization = try? persistence.fetch(heroID: Int(hero.id), language: language, context: context) else {
                logger.error("Failed to fetch localization for hero \(hero.id)")
                continue
            }
            
            heroData.append(HeroData(hero: hero, localization: localization))
        }
        self.heroes = heroData.sorted { $0.localizedName < $1.localizedName }
        self.searchResults = self.heroes
    }
    
    private func fetchHeroes() -> [Hero] {
        do {
            let request = Hero.fetchRequest()
            let sort = NSSortDescriptor(key: "id", ascending: true)
            request.sortDescriptors = [sort]
            let heroes = try context.fetch(request)
            return heroes
        } catch {
            logger.error("Failed to fetch hero. error: \(error)")
            return []
        }
    }
}
