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
    
    var heroes = [Hero]()
    
    var gameModes = [String: GameMode]()
    
    var items = [String: Item]()
    var itemIDTable = [String: String]()
    
    static var shared = HeroDatabase()
    
    let url = "https://api.opendota.com/api/herostats"
    
    init() {
        self.loading = true
        self.gameModes = loadGameModes()!
        self.loadHeroes()
        self.itemIDTable = loadItemIDs()!
        self.items = loadItems()!
    }
    
    private func loadHeroes() {
        AF.request(url).responseJSON { response in
            guard let data = response.data else {
                return
            }
            let decoder = JSONDecoder()
            let heroes = try? decoder.decode([Hero].self, from: data)
            self.heroes = heroes!
            DispatchQueue.main.async {
                self.loading = false
            }
        }
    }
    
    func fetchHeroWithID(id: Int) -> Hero? {
        return heroes.first(where: { $0.id == id })
    }
    
    func fetchGameMode(id: Int) -> GameMode {
        return gameModes["\(id)"]!
    }
    
    func fetchItem(id: Int) -> Item? {
        if id == 0 {
            return nil
        } else {
            let itemString = itemIDTable["\(id)"]!
            let item = items[itemString]!
            return item
        }
    }
    
}
