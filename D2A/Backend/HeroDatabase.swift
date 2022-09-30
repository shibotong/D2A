//
//  HeroDatabase.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import SwiftUI

enum LoadingStatus {
    case loading, error, finish
}

class HeroDatabase: ObservableObject {
    @Published var status: LoadingStatus = .loading
    var heroes = [String: HeroModel]()
    var gameModes = [String: GameMode]()
    var lobbyTypes = [String: LobbyType]()
    var regions = [String: String]()
    var items = [String: Item]()
    var itemIDTable = [String: String]()
    var abilityIDTable = [String: String]()
    var abilities = [String: Ability]()
    var heroAbilities = [String: HeroAbility]()
    var talentData = [String: String]()
    var scepterData = [HeroScepter]()
    var apolloAbilities = [AbilityQuery.Data.Constant.Ability]()
    
    static var shared = HeroDatabase()
    static var preview: HeroDatabase {
        let base = HeroDatabase()
        base.status = .error
        return base
    }
    
    let url = "https://api.opendota.com/api/herostats"
    
    init() {
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
                    self.status = .error
                } else {
                    self.status = .finish
                }
            }
        }
        
        
    }

    func fetchHeroWithID(id: Int) -> HeroModel? {
        return heroes["\(id)"]
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
    
    func fetchAbility(name: String) -> Ability? {
        return abilities[name]
    }
    
    func fetchHeroAbility(name: String) -> HeroAbility? {
        return heroAbilities[name]
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
                    print("stratz abilities load successfully")
                }
                
                if let errors = graphQLResult.errors {
                    let message = errors
                        .map { $0.localizedDescription }
                        .joined(separator: "\n")
                    print(message)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}
