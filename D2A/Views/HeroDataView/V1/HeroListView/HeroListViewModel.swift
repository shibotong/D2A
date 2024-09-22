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
    @Published var heroList: [Hero]
    
    @Published var searchResults: [Hero]
    
    @Published var searchString: String = ""
    @Published var gridView = true
    @Published var selectedAttribute: HeroAttribute = .whole
    let viewContext: NSManagedObjectContext
    
    private var subscribers = Set<AnyCancellable>()
    
    init(viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        heroList = []
        self.viewContext = viewContext
        searchString = ""
        searchResults = []
        selectedAttribute = .whole
        registerNotification()
        fetchAllHeroes()
    }
    
    private func fetchAllHeroes() {
        heroList = Hero.fetchAllHeroes(viewContext: viewContext, sortDescriptors: [NSSortDescriptor(keyPath: \Hero.id, ascending: true)])
    }
    
    private func registerNotification() {
        NotificationCenter.default.publisher(for: .dataDidSave)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.fetchAllHeroes()
            }
            .store(in: &subscribers)
        
        $searchString
            .combineLatest($selectedAttribute)
            .map { [weak self] searchString, attributes in
                guard let self = self else { return [] }
                let filterHeroes = attributes == .whole ? self.heroList : self.heroList.filter({ return $0.primaryAttr == attributes.rawValue })
                if searchString.isEmpty {
                    return filterHeroes
                } else {
                    let searchedHeroes = filterHeroes.filter({ hero in
                        let localizedName = hero.heroNameLocalized.lowercased().contains(searchString.lowercased())
                        return localizedName
                    })
                    return searchedHeroes
                }
            }
            .sink { [weak self] results in
                self?.searchResults = results
            }
            .store(in: &subscribers)
        
        $heroList
            .assign(to: &$searchResults)
    }
}
