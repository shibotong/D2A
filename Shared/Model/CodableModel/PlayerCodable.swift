//
//  PlayerCodable.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import Foundation

struct PlayerCodable: Decodable {
  var accountId: Int?
  var slot: Int
  var abilityUpgrade: [Int]?  // An array describing how abilities were upgraded

  // backpack
  var backpack0: Int?
  var backpack1: Int?
  var backpack2: Int?
  // item
  var item0: Int
  var item1: Int
  var item2: Int
  var item3: Int
  var item4: Int
  var item5: Int
  var itemNeutral: Int?

  // K/D/A lasthit/deny
  var kills: Int
  var deaths: Int
  var assists: Int
  var lastHits: Int
  var denies: Int

  var gpm: Int
  var gold_t: [Int]?
  var netWorth: Int?
  var xpm: Int
  var xp_t: [Int]?

  var heroDamage: Int?
  var heroHealing: Int?

  var heroID: Int
  var level: Int

  var permanentBuffs: [PermanentBuffCodable]?

  var teamFightParticipation: Double?
  var towerDamage: Int?

  var personaname: String?

  var multiKills: [String: Int]?

  var rank: Int?

  enum CodingKeys: String, CodingKey {
    case accountId = "account_id"
    case slot = "player_slot"
    case abilityUpgrade = "ability_upgrades_arr"

    // backpack
    case backpack0 = "backpack_0"
    case backpack1 = "backpack_1"
    case backpack2 = "backpack_2"
    // items
    case item0 = "item_0"
    case item1 = "item_1"
    case item2 = "item_2"
    case item3 = "item_3"
    case item4 = "item_4"
    case item5 = "item_5"
    case itemNeutral = "item_neutral"
    // KDA
    case deaths
    case denies
    case assists
    case kills
    case lastHits = "last_hits"

    case gpm = "gold_per_min"
    case gold_t
    case xpm = "xp_per_min"
    case xp_t
    case netWorth = "net_worth"

    case heroDamage = "hero_damage"
    case heroHealing = "hero_healing"
    case heroID = "hero_id"
    case level

    case permanentBuffs = "permanent_buffs"
    case teamFightParticipation = "teamfight_participation"
    case towerDamage = "tower_damage"

    case personaname
    case multiKills = "multi_kills"

    case rank = "rank_tier"
  }
}

struct PermanentBuffCodable: Decodable {
  var buffID: Int
  var stack: Int

  enum CodingKeys: String, CodingKey {
    case buffID = "permanent_buff"
    case stack = "stack_count"
  }
}
