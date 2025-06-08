//
//  ReadData.swift
//  Dota Portfolio
//
//  Created by 佟诗博 on 4/7/21.
//

import Foundation

private func loadFile(filename: String) -> Data? {
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

func loadRecentMatches() -> [RecentMatchCodable]? {
  guard let data = loadFile(filename: "sampleRecentMatch") else {
    return nil
  }
  do {
    let decoder = JSONDecoder()
    let jsonData = try decoder.decode([RecentMatchCodable].self, from: data)
    return jsonData
  } catch {
    // handle error
    debugPrint(error)
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
    debugPrint(error)
    return nil
  }
}

func loadScepter() async -> [HeroScepter] {
  let urlString =
    "https://raw.githubusercontent.com/odota/dotaconstants/master/build/aghs_desc.json"
  if let url = URL(string: urlString) {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)

      let decoder = JSONDecoder()
      let jsonData = try decoder.decode([HeroScepter].self, from: data)
      return jsonData
    } catch {
      debugPrint("Load Scepter", error)
      return []
    }
  } else {
    return []
  }
}

func loadHeroes() async -> [String: ODHero] {
  let urlString = "https://raw.githubusercontent.com/odota/dotaconstants/master/build/heroes.json"
  if let url = URL(string: urlString) {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)

      let decoder = JSONDecoder()
      let jsonData = try decoder.decode([String: ODHero].self, from: data)
      return jsonData
    } catch {
      debugPrint("Load Heroes", error)
      return [:]
    }
  } else {
    return [:]
  }
}

func loadHeroAbilities() async -> [String: ODHeroAbilities] {
  let urlString =
    "https://raw.githubusercontent.com/odota/dotaconstants/master/build/hero_abilities.json"
  if let url = URL(string: urlString) {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)

      let decoder = JSONDecoder()
      let jsonData = try decoder.decode([String: ODHeroAbilities].self, from: data)
      return jsonData
    } catch {
      debugPrint("Load Abilities", error)
      return [:]
    }
  } else {
    return [:]
  }
}

func loadProfile() -> UserProfileCodable? {
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
    debugPrint(error)
    return nil
  }
}

func loadSampleAbilities() -> [String: ODAbility]? {
  guard let data = loadFile(filename: "sampleAbility") else {
    return nil
  }
  do {
    let decoder = JSONDecoder()
    let jsonData = try decoder.decode([String: ODAbility].self, from: data)
    return jsonData
  } catch {
    debugPrint(error)
    return nil
  }
}

func loadSampleHero() -> [String: ODHero]? {
  guard let data = loadFile(filename: "sampleHero") else {
    return nil
  }

  do {
    let decoder = JSONDecoder()
    let jsonData = try decoder.decode([String: ODHero].self, from: data)
    return jsonData
  } catch {
    debugPrint(error)
    return nil
  }
}

func loadSampleItemID() -> [String: String] {
  guard let data = loadFile(filename: "sampleItemID") else {
    return [:]
  }

  do {
    let decoder = JSONDecoder()
    let jsonData = try decoder.decode([String: String].self, from: data)
    return jsonData
  } catch {
    debugPrint(error)
    return [:]
  }
}

func loadSampleItem() -> [String: Item] {
  guard let data = loadFile(filename: "sampleItem") else {
    return [:]
  }

  do {
    let decoder = JSONDecoder()
    let jsonData = try decoder.decode([String: Item].self, from: data)
    return jsonData
  } catch {
    debugPrint(error)
    return [:]
  }
}

func loadAbilityID() async -> [String: String] {
  let urlString =
    "https://raw.githubusercontent.com/odota/dotaconstants/master/build/ability_ids.json"
  if let url = URL(string: urlString) {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      let decoder = JSONDecoder()
      let jsonData = try decoder.decode([String: String].self, from: data)
      return jsonData
    } catch {
      debugPrint("Load Ability ID", error)
      return [:]
    }
  } else {
    return [:]
  }
}

func loadAbilities() async -> [String: ODAbility] {
  let urlString =
    "https://raw.githubusercontent.com/odota/dotaconstants/master/build/abilities.json"
  if let url = URL(string: urlString) {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)

      let decoder = JSONDecoder()
      let jsonData = try decoder.decode([String: ODAbility].self, from: data)
      return jsonData
    } catch {
      debugPrint("Load Abilities", error)
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
    debugPrint(error)
    return nil
  }

}

func loadItemIDs() async -> [String: String] {
  let urlString = "https://raw.githubusercontent.com/odota/dotaconstants/master/build/item_ids.json"
  if let url = URL(string: urlString) {
    do {
      let (data, _) = try await URLSession.shared.data(from: url)
      guard
        let itemIDs = try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
      else {
        return [:]
      }
      return itemIDs
    } catch {
      debugPrint("Load Item IDs", error)
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
      debugPrint("Load Items", error)
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
    debugPrint(error)
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
