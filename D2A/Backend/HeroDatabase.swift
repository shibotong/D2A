//
//  HeroDatabase.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import SwiftUI
import Combine

enum LoadingStatus {
    case loading, error, finish
}

class HeroDatabase: ObservableObject {
    
    enum HeroDataError: Error {
        case heroNotFound
    }
    
    @Published var status: LoadingStatus = .loading
    private var heroes = [String: HeroModel]()
    private var gameModes = [String: GameMode]()
    private var lobbyTypes = [String: LobbyType]()
    private var regions = [String: String]()
    private var items = [String: Item]()
    private var itemIDTable = [String: String]()
    private var abilityIDTable = [String: String]()
    private var abilities = [String: Ability]()
    private var heroAbilities = [String: HeroAbility]()
    private var talentData = [String: String]()
    private var scepterData = [HeroScepter]()
    private var apolloAbilities = [AbilityQuery.Data.Constant.Ability]()
    
    static var shared = HeroDatabase()
    static var preview: HeroDatabase {
        let base = HeroDatabase()
        base.status = .error
        return base
    }
    
    @Published private var openDotaLoadFinish: LoadingStatus = .loading
    @Published private var stratzLoadFinish: LoadingStatus = .loading
    private var cancellable = Set<AnyCancellable>()
    
    let url = "https://api.opendota.com/api/herostats"
    
    init() {
        Publishers
            .CombineLatest($openDotaLoadFinish, $stratzLoadFinish)
            .map({ opendota, stratz in
                print(opendota, stratz)
                if opendota == .error || stratz == .error {
                    return .error
                }
                if opendota == .finish && stratz == .finish {
                    return .finish
                }
                return .loading
            })
            .assign(to: \.status, on: self)
            .store(in: &cancellable)
        
        self.status = .loading
        self.gameModes = loadGameModes()
        self.regions = loadRegion()!
        self.lobbyTypes = loadLobby()!
        
        self.loadStratzAbilities()
        
        Task {
            async let idTable = loadItemIDs()
            async let items = loadItems()
            async let heroes = loadHeroes()
            async let abilityIDTable = loadAbilityID()
            async let abilities = loadAbilities()
            async let heroAbilities = loadHeroAbilities()
            async let talentData = loadTalentData()
            async let scepter = loadScepter()
            
            self.itemIDTable = await idTable
            self.items = await items
            self.heroes = await heroes
            self.abilityIDTable = await abilityIDTable
            self.abilities = await abilities
            self.heroAbilities = await heroAbilities
            self.talentData = await talentData
            self.scepterData = await scepter
            
            DispatchQueue.main.async {
                if self.abilities.count == 0 {
                    self.openDotaLoadFinish = .error
                } else {
                    self.openDotaLoadFinish = .finish
                }
            }
        }
    }

    func fetchHeroWithID(id: Int) throws -> HeroModel {
        guard let hero = heroes["\(id)"] else {
            throw Self.HeroDataError.heroNotFound
        }
        return hero
    }
    
    func fetchGameMode(id: Int) -> GameMode {
        return gameModes["\(id)"]!
    }
    
    func fetchItem(id: Int) -> Item? {
        if id == 0 {
            return nil
        } else {
            guard let itemString = itemIDTable["\(id)"] else {
                return nil
            }
            guard let item = items[itemString] else {
                return nil
            }
            return item
        }
    }
    
    func fetchRegion(id: String) -> String {
        guard let region = self.regions[id] else {
            return "Unknown"
        }
        return region
    }
    
    func fetchLobby(id: Int) -> LobbyType {
        return lobbyTypes["\(id)"] ?? LobbyType(id: id, name: "Unknown Lobby")
    }
    
    func fetchAbilityName(id: Int) -> String? {
        guard let abilityName = self.abilityIDTable["\(id)"] else {
            return nil
        }
        return abilityName
    }
    
    func fetchOpenDotaAbility(name: String) -> Ability? {
        return abilities[name]
    }
    
    func fetchStratzAbility(name: String) -> AbilityQuery.Data.Constant.Ability? {
        let ability = apolloAbilities.first { $0.name == name }
        return ability
    }
    
    func fetchHeroAbility(name: String) -> [String] {
        let abilities = heroAbilities[name]?.abilities
        return abilities ?? []
    }
    
    func fetchAllHeroes() -> [HeroModel] {
        var sortedHeroes = [HeroModel]()
        for i in 1..<150 {
            if let hero = heroes["\(i)"] {
                sortedHeroes.append(hero)
            }
        }
        
        sortedHeroes.sort { hero1, hero2 in
            return hero1.localizedName < hero2.localizedName
        }
        return sortedHeroes
    }
    
    func fetchSearchedHeroes(text: String) -> [HeroModel] {
        return []
    }
    
    func getAbilityScepterDesc(ability: Ability, heroID: Int) -> String? {
        guard let hero = self.scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return nil
        }
        if ability.dname == hero.scepterSkillName {
            return hero.scepterDesc
        }
        return nil
    }
    
    func isScepterSkill(ability: Ability, heroID: Int) -> Bool {
        guard let hero = self.scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        if ability.dname == hero.scepterSkillName && hero.scepterNewSkill {
            return true
        } else {
            return false
        }
    }
    
    func isShardSkill(ability: Ability, heroID: Int) -> Bool {
        guard let hero = self.scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        if ability.dname == hero.shardSkillName && hero.shardNewSkill {
            return true
        } else {
            return false
        }
    }
    
    func hasScepter(ability: Ability, heroID: Int) -> Bool {
        guard let hero = self.scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        if ability.dname == hero.scepterSkillName {
            return true
        } else {
            return false
        }
    }
    
    func hasShard(ability: Ability, heroID: Int) -> Bool {
        guard let hero = self.scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return false
        }
        if ability.dname == hero.shardSkillName {
            return true
        } else {
            return false
        }
    }
    
    func getAbilityShardDesc(ability: Ability, heroID: Int) -> String? {
        guard let hero = self.scepterData.filter({ scepter in
            scepter.id == heroID
        }).first else {
            // Cannot find this hero
            return nil
        }
        if ability.dname == hero.shardSkillName {
            print("\(hero.shardDesc)")
            return hero.shardDesc
        }
        return nil
    }
    
    func getTalentDisplayName(id: Short) -> String {
        let talent = self.apolloAbilities.first { ability in
            return ability.id == id
        }
        return talent?.language?.displayName ?? "Fetch String Error"
    }
    
    // MARK: - private functions
    private func loadStratzAbilities() {
        Network.shared.apollo.fetch(query: AbilityQuery(language: languageCode)) { [weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let graphQLResult):
                if let abilitiesConnection = graphQLResult.data?.constants?.abilities {
                    let abilities = abilitiesConnection.compactMap({ $0 })
                    self.apolloAbilities = abilities
                    DispatchQueue.main.async {
                        self.stratzLoadFinish = .finish
                    }
                }
                
                if let errors = graphQLResult.errors {
                    let message = errors
                        .map { $0.localizedDescription }
                        .joined(separator: "\n")
                    DispatchQueue.main.async {
                        self.stratzLoadFinish = .error
                    }
                    print(message)
                }
            case .failure(let error):
                print(error)
                DispatchQueue.main.async {
                    self.stratzLoadFinish = .error
                }
            }
        }
    }
    
    private func networkFetchFinishCheck() {
        
    }
}
