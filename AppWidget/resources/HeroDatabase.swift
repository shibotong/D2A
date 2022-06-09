//
//  HeroDatabase.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation

class HeroDatabase {
    var gameModes = [String: GameMode]()
    var lobbyTypes = [String: LobbyType]()
    var heroes = [String: Hero]()

    static var shared = HeroDatabase()
    
    let url = "https://api.opendota.com/api/herostats"
    
    init() {
        self.gameModes = loadGameModes()
        self.lobbyTypes = loadLobby()!
        Task {
            await self.heroes = loadHeroes()
        }
    }
    
    func fetchGameMode(id: Int) -> GameMode {
        return gameModes["\(id)"]!
    }
    
    func fetchLobby(id: Int) -> LobbyType {
        return lobbyTypes["\(id)"]!
    }
    
    func fetchHeroWithID(id: Int) -> Hero? {
        return heroes["\(id)"]
    }
}
