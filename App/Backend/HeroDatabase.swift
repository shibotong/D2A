//
//  HeroDatabase.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import Alamofire
import SwiftUI

class HeroDatabase: ObservableObject {
    @Published var loading = false
    var heroes = [String: Hero]()
    var gameModes = [String: GameMode]()
    var lobbyTypes = [String: LobbyType]()
    var regions = [String: String]()
    var items = [String: Item]()
    var itemIDTable = [String: String]()
    var abilityIDTable = [String: String]()
    var abilities = [String: Ability]()
    
    static var shared = HeroDatabase()
    
    let url = "https://api.opendota.com/api/herostats"
    
    init() {
        self.loading = true
        self.gameModes = loadGameModes()!
        self.heroes = loadHeroes()!
        self.itemIDTable = loadItemIDs()!
        self.items = loadItems()!
        self.regions = loadRegion()!
        self.lobbyTypes = loadLobby()!
        self.abilityIDTable = loadAbilityID()
        self.abilities = loadAbilities()
    }
    
    func fetchHeroWithID(id: Int) -> Hero? {
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
        return lobbyTypes["\(id)"]!
    }
    
    func fetchAbility(id: Int) -> Ability? {
        guard let abilityName = self.abilityIDTable["\(id)"] else {
            return nil
        }
        return abilities[abilityName]
    }
}
