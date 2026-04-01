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
    
    @Published var searchResults: [any HeroProtocol]
    @Published var heroes: [any HeroProtocol]
    
    @Published var searchString: String = ""
    @Published var gridView = true
    @Published var selectedAttribute: HeroAttribute = .whole
    
    private var subscribers = Set<AnyCancellable>()
    private let context: NSManagedObjectContext
    private let language: DataLanguageEnum
    private let logger: Logger
    
    init(context: NSManagedObjectContext = PersistanceController.shared.mainContext,
         language: DataLanguageEnum = AppConfig.languageCode,
         logger: Logger = D2ALogger.ui) {
        self.context = context
        self.language = language
        self.logger = logger
        heroes = []
        searchString = ""
        searchResults = []
        selectedAttribute = .whole
        fetchData()
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
                        let localizedName = hero.displayName.lowercased().contains(searchString.lowercased())
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
            guard let localization = try? HeroTranslation.fetch(id: Int(hero.id), language: language, context: context) else {
                logger.error("Failed to fetch localization for hero \(hero.id)")
                continue
            }
            heroData.append(HeroData(hero: hero, localization: localization))
        }
        self.heroes = heroData.sorted { $0.displayName < $1.displayName }
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
