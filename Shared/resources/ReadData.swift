//
//  ReadData.swift
//  Dota Portfolio
//
//  Created by 佟诗博 on 4/7/21.
//

import Foundation

fileprivate func loadFile(filename: String) -> Data? {
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

func loadRecentMatches() -> [RecentMatch]? {
    guard let data = loadFile(filename: "sampleRecentMatch") else {
        return nil
    }
    do {
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode([RecentMatch].self, from: data)
        return jsonData
    } catch {
        // handle error
        print("Cannot parse json data")
        return nil
    }

}

func loadLobby() -> [String: LobbyType]? {
    guard let data = loadFile(filename: "lobby_type") else {
        return nil
    }
    do {
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode([String: LobbyType].self, from: data)
        return jsonData
    } catch {
        print("Cannot parse Lobby data")
        return nil
    }
}

func loadTalentData() async -> [String: String] {
    let urlString = "https://raw.githubusercontent.com/shibotong/Dota2-talent-data/main/talent.json"
    if let url = URL(string: urlString) {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([String: String].self, from: data)
            return jsonData
        } catch {
            print(error.localizedDescription)
            return [:]
        }
    } else {
        return [:]
    }
}

func loadScepter() async -> [HeroScepter] {
    let urlString = "https://raw.githubusercontent.com/odota/dotaconstants/master/build/aghs_desc.json"
    if let url = URL(string: urlString) {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([HeroScepter].self, from: data)
            return jsonData
        } catch {
            print(error.localizedDescription)
            return []
        }
    } else {
        return []
    }
}

func loadHeroes() async -> [String: HeroModel] {
    let urlString = "https://raw.githubusercontent.com/odota/dotaconstants/master/build/heroes.json"
    if let url = URL(string: urlString) {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([String: HeroModel].self, from: data)
            return jsonData
        } catch {
            print(error.localizedDescription)
            return [:]
        }
    } else {
        return [:]
    }
}

func loadHeroAbilities() async -> [String: HeroAbility] {
    let urlString = "https://raw.githubusercontent.com/odota/dotaconstants/master/build/hero_abilities.json"
    if let url = URL(string: urlString) {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([String: HeroAbility].self, from: data)
            return jsonData
        } catch {
            print(error.localizedDescription)
            return [:]
        }
    } else {
        return [:]
    }
}

func loadProfile() -> UserProfile? {
    guard let data = loadFile(filename: "sampleProfile") else {
        return nil
    }
    do {
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(SteamProfile.self, from: data)
        var userprofile = jsonData.profile
        userprofile.rank = jsonData.rank
        userprofile.leaderboard = jsonData.leaderboard
        return userprofile
    } catch {
        // handle error
        print("Cannot parse json data")
        return nil
    }
}

func loadSampleHero() -> HeroModel? {
    guard let data = loadFile(filename: "sampleHero") else {
        return nil
    }
    
    do {
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(HeroModel.self, from: data)
        return jsonData
    } catch {
        print("Cannot parse json data")
        return nil
    }
}

func loadAbilityID() async -> [String: String] {
    let urlString = "https://raw.githubusercontent.com/odota/dotaconstants/master/build/ability_ids.json"
    if let url = URL(string: urlString) {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([String: String].self, from: data)
            return jsonData
        } catch {
            return [:]
        }
    } else {
        return [:]
    }
}

func loadAbilities() async -> [String: Ability] {
    let urlString = "https://raw.githubusercontent.com/odota/dotaconstants/master/build/abilities.json"
    if let url = URL(string: urlString) {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([String: Ability].self, from: data)
            return jsonData
        } catch {
            print("Cannot parse Lobby data")
            return [:]
        }
    } else {
        return [:]
    }
}

func loadMatch() -> MatchCodable? {
    guard let data = loadFile(filename: "sampleMatch") else {
        return nil
    }

    do {
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(MatchCodable.self, from: data)
        return jsonData
    } catch {
        print("Cannot parse json data")
        return nil
    }

}

func loadItemIDs() async -> [String: String] {
    let urlString = "https://raw.githubusercontent.com/odota/dotaconstants/master/build/item_ids.json"
    if let url = URL(string: urlString) {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return try (JSONSerialization.jsonObject(with: data, options: []) as! [String : String])
        } catch {
            print(error.localizedDescription)
            return [:]
        }
    } else {
        return [:]
    }

}

func loadItems() async -> [String: Item] {
    let urlString = "https://raw.githubusercontent.com/odota/dotaconstants/master/build/items.json"
    if let url = URL(string: urlString) {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode([String: Item].self, from: data)
            return jsonData
        } catch {
            print(error.localizedDescription)
            return [:]
        }
    } else {
        return [:]
    }
}

func loadGameModes() -> [String: GameMode] {
    guard let data = loadFile(filename: "game_mode") else {
        fatalError("no game mode file")
    }
    do {
        let decoder = JSONDecoder()
        let modes = try decoder.decode([String: GameMode].self, from: data)
        return modes
    } catch {
        print(error.localizedDescription)
        return [:]
    }
}

func loadRegion() -> [String: String]? {
    guard let data = loadFile(filename: "region") else {
        fatalError("no region file")
    }
    do {
        let decoder = JSONDecoder()
        let regions = try decoder.decode([String: String].self, from: data)
        return regions
    } catch {
        print("cannot parse mode file")
        return nil
    }
}
