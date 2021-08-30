//
//  HeroDatabase.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import Alamofire

class HeroDatabase: ObservableObject {
    @Published var loading = false
    var heroes = [String: Hero]()
    var gameModes = [String: GameMode]()
    var lobbyTypes = [String: LobbyType]()
    var regions = [String: String]()
    var items = [String: Item]()
    var itemIDTable = [String: String]()
    
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
    }
    
//    private func loadHeroes() {
//        AF.request(url).responseJSON { response in
//            guard let data = response.data else {
//                return
//            }
//            guard let statusCode = response.response?.statusCode else {
//                return
//            }
//            if statusCode > 400 {
//                DotaEnvironment.shared.exceedLimit = true
//            }
//            let decoder = JSONDecoder()
//            let heroes = try? decoder.decode([Hero].self, from: data)
//            guard let fetchedHeroes = heroes else {
//                return
//            }
//            self.heroes = fetchedHeroes
//            DispatchQueue.main.async {
//                self.loading = false
//            }
//        }
//    }
    
    func fetchHeroWithID(id: Int) -> Hero? {
        return heroes["\(id)"]
//        return heroes.first(where: { $0.id == id })
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
    
}
