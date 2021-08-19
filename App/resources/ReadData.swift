//
//  ReadData.swift
//  Dota Portfolio
//
//  Created by 佟诗博 on 4/7/21.
//

import Foundation

func loadFile(filename: String) -> Data? {
    if let path = Bundle.main.url(forResource: filename, withExtension: "json") {
        do {
            let data = try Data(contentsOf: path)
            return data
        } catch {
            print("No such file")
            return nil
        }
    } else {
        return nil
    }
}
//
//func loadRecentMatches() -> [RecentMatch]? {
//    guard let data = loadFile(filename: "sampleMatches") else {
//        return nil
//    }
//    do {
//        let decoder = JSONDecoder()
//        let jsonData = try decoder.decode([RecentMatch].self, from: data)
//        return jsonData
//    } catch {
//        // handle error
//        print("Cannot parse json data")
//        return nil
//    }
//
//}
//
//func loadProfile() -> SteamProfile? {
//    guard let data = loadFile(filename: "sampleProfile") else {
//        return nil
//    }
//
//    do {
//
//        let decoder = JSONDecoder()
//        let jsonData = try decoder.decode(SteamProfile.self, from: data)
//        return jsonData
//    } catch {
//        // handle error
//        print("Cannot parse json data")
//        return nil
//    }
//}
//
//func loadHeroes() -> [PlayerHero]? {
//    guard let data = loadFile(filename: "sampleHeroes") else {
//        return nil
//    }
//
//    do {
//        let decoder = JSONDecoder()
//        let jsonData = try decoder.decode([PlayerHero].self, from: data)
//        return jsonData
//    } catch {
//        // handle error
//        print("Cannot parse json data")
//        return nil
//    }
//
//}
//
func loadMatch() -> Match? {
    guard let data = loadFile(filename: "sampleMatch") else {
        return nil
    }

    do {
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(Match.self, from: data)
        return jsonData
    } catch {
        print("Cannot parse json data")
        return nil
    }

}
//
func loadItemIDs() -> [String: String]? {
    guard let data = loadFile(filename: "itemID") else {
        return nil
    }

    do {
        return try (JSONSerialization.jsonObject(with: data, options: []) as? [String : String])
    } catch {
        print("Cannot parse json data")
        return nil
    }

}
//
func loadItems() -> [String: Item]? {
    guard let data = loadFile(filename: "items") else {
        return nil
    }
    do {
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode([String: Item].self, from: data)
        return jsonData
    } catch {
        print("Cannot parse json data")
        return nil
    }
}
//
func loadGameModes() -> [String: GameMode]? {
    guard let data = loadFile(filename: "dota_game_mode") else {
        fatalError("no game mode file")
    }
    do {
        let decoder = JSONDecoder()
        let modes = try decoder.decode([String: GameMode].self, from: data)
        return modes
    } catch {
        print("cannot parse mode file")
        return nil
    }
}



