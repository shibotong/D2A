//
//  HeroDetailViewModel.swift
//  App
//
//  Created by Shibo Tong on 15/5/2022.
//

import Apollo
import CoreData
import Foundation
import StratzAPI
import UIKit

class HeroDetailViewModel: ObservableObject {
    @Published var hero: Hero?
    @Published var selectedAbility: ODAbility?

    @Published var heroID: Int

    @Published var previousHeroID: Int?
    @Published var nextHeroID: Int?

    @Published var loadingHero: Bool

    @Published var abilities: [ODAbility] = []

    private var database: ConstantsController = ConstantsController.shared

    init(heroID: Int) {
        self.heroID = heroID
        loadingHero = false
        $heroID
            .map { [weak self] heroID in
                let cachedHero = Hero.fetchHero(id: Double(heroID))
                self?.loadHero(hero: cachedHero, id: heroID)
                return cachedHero
            }
            .assign(to: &$hero)

        $heroID
            .map { [weak self] id in
                return self?.getRelateHeroID(id: id, isPrevious: false)
            }
            .assign(to: &$nextHeroID)

        $heroID
            .map { [weak self] id in
                return self?.getRelateHeroID(id: id, isPrevious: true)
            }
            .assign(to: &$previousHeroID)

        //        $hero
        //            .map { [weak self] hero in
        //                guard let abilityNames = hero?.abilities else {
        //                    return []
        //                }
        //                let abilities = abilityNames.filter { ability in
        //                    let containHidden = ability.contains("hidden")
        //                    let containEmpty = ability.contains("empty")
        //                    return !containHidden && !containEmpty
        //                }.compactMap { [weak self] abilityName in
        //                    self?.database.fetchOpenDotaAbility(name: abilityName)
        //                }
        //                self?.selectedAbility = abilities.first
        //                return abilities
        //            }
        //            .assign(to: &$abilities)
    }

    /// Load hero
    func loadHero(hero: Hero?, id: Int) {
        if let lastFetch = hero?.lastFetch, lastFetch.startOfDay == Date().startOfDay {
            // if hero exist and already fetched today, dont download hero
            return
        }
        downloadHero(heroID: id)
    }

    /// Download hero from API
    func downloadHero(heroID: Int) {
        loadingHero = true
        Network.shared.apollo.fetch(query: HeroQuery(id: Double(heroID))) {
            [weak self] (result: Result<GraphQLResult<HeroQuery.Data>, Error>) in
            guard let self = self else { return }
            switch result {
            case .success(let graphQLResult):
                if let hero = graphQLResult.data?.constants?.hero {
                    do {
                        let model = try self.database.fetchHeroWithID(id: self.heroID)
                        let abilities = self.database
                            .fetchHeroAbility(name: model.name)
                            .filter { ability in
                                return !ability.contains("hidden") && !ability.contains("empty")
                            }
                        let newHero = try Hero.createHero(hero, model: model, abilities: abilities)
                        DispatchQueue.main.async { [weak self] in
                            self?.hero = newHero
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }

                if let errors = graphQLResult.errors {
                    let message =
                        errors
                        .map { $0.localizedDescription }
                        .joined(separator: "\n")
                    print(message)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }

            loadingHero = false
        }
    }

    func fetchTalentName(id: Short) -> String {
        return database.getTalentDisplayName(id: id)
    }

    func getRelateHeroID(id: Int, isPrevious: Bool) -> Int? {
        let heroList = ConstantsController.shared.fetchAllHeroes().sorted {
            $0.heroNameLocalized < $1.heroNameLocalized
        }
        let heroIndex = heroList.firstIndex { $0.id == id } ?? 0
        var index = 0
        if isPrevious {
            index = heroIndex + 1
            if heroIndex == heroList.endIndex {
                index = heroList.startIndex
            }
        } else {
            index = heroIndex - 1
            if heroIndex == heroList.startIndex {
                index = heroList.endIndex
            }
        }
        guard index >= 0 && index < heroList.count else {
            return nil
        }
        let nextHero = heroList[index]
        let nextHeroID = nextHero.id
        return nextHeroID
    }

    //    func getNextHeroID(id: Int) -> Int? {
    //        let heroList = ConstantsController.shared.fetchAllHeroes().sorted { $0.heroNameLocalized < $1.heroNameLocalized }
    //        let heroIndex = heroList.firstIndex { $0.id == id } ?? 0
    //        var nextIndex = heroIndex + 1
    //        if nextIndex == heroList.endIndex {
    //            nextIndex = 0
    //        }
    //        guard nextIndex >= 0 && nextIndex < heroList.count else {
    //            return nil
    //        }
    //        let nextHero = heroList[nextIndex]
    //        let nextHeroID = nextHero.id
    //        return nextHeroID
    //    }
    //
    //    func getPreviousHeroID(id: Int) -> Int? {
    //        let heroList = ConstantsController.shared.fetchAllHeroes().sorted { $0.heroNameLocalized < $1.heroNameLocalized }
    //        let heroIndex = heroList.firstIndex { $0.id == id } ?? 0
    //        var previousIndex = heroIndex - 1
    //        if heroIndex == heroList.startIndex {
    //            previousIndex = heroList.endIndex - 1
    //        }
    //        guard previousIndex >= 0 && previousIndex < heroList.count else {
    //            return nil
    //        }
    //        let previousHero = heroList[previousIndex]
    //        let previousHeroID = previousHero.id
    //        return previousHeroID
    //    }
}
