//
//  Player.swift
//  D2A
//
//  Created by Shibo Tong on 23/10/2022.
//

import Foundation
import WCDBSwift

struct Player: Codable, TableCodable, Identifiable {
    var id = UUID()
    var accountId: Int?
    var slot: Int
    var abilityUpgrade: [Int]? //An array describing how abilities were upgraded
    
    // backpack
    var backpack0: Int?
    var backpack1: Int?
    var backpack2: Int?
    // item
    var item0:Int
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

    var permanentBuffs: [PermanentBuff]?

    var teamFightParticipation: Double?
    var towerDamage: Int?

    var personaname: String?
    
    var multiKills: [String: Int]?
    
    var rank: Int?
    
    var positionX: Int?
    var positionY: Int?
    
    var deathEvents: [Int]?
    var killEvents: [Int]?
    
    init(from player: MatchLiveSubscription.Data.MatchLive.Player) {
        accountId = player.steamAccountId ?? 0
        slot = player.playerSlot ?? 0
        backpack0 = Int(player.backpackId0 ?? 0)
        backpack1 = Int(player.backpackId1 ?? 0)
        backpack2 = Int(player.backpackId2 ?? 0)
        item0 = Int(player.itemId0 ?? 0)
        item1 = Int(player.itemId1 ?? 0)
        item2 = Int(player.itemId2 ?? 0)
        item3 = Int(player.itemId3 ?? 0)
        item4 = Int(player.itemId4 ?? 0)
        item5 = Int(player.itemId5 ?? 0)
        
        kills = player.numKills ?? 0
        deaths = player.numDeaths ?? 0
        assists = player.numAssists ?? 0
        lastHits = Int(player.numLastHits ?? 0)
        denies = Int(player.numDenies ?? 0)
        
        gpm = Int(player.goldPerMinute ?? 0)
        netWorth = player.networth
        xpm = Int(player.experiencePerMinute ?? 0)
        
        heroDamage = player.heroDamage
        heroID = Int(player.heroId ?? 0)
        level = player.level ?? 0
        
        personaname = player.steamAccount?.proSteamAccount?.name ?? player.steamAccount?.name
        rank = player.steamAccount?.seasonRank
        
        positionX = player.playbackData?.positionEvents?.first??.x
        positionY = player.playbackData?.positionEvents?.first??.y
        
        killEvents = player.playbackData?.killEvents?.compactMap({ $0 }).map{ $0.time }
        deathEvents = player.playbackData?.deathEvents?.compactMap({ $0 }).map{ $0.time }
    }
    
    init(from player: MatchLiveHistoryQuery.Data.Live.Match.Player) {
        accountId = player.steamAccountId ?? 0
        slot = player.playerSlot ?? 0
        backpack0 = Int(player.backpackId0 ?? 0)
        backpack1 = Int(player.backpackId1 ?? 0)
        backpack2 = Int(player.backpackId2 ?? 0)
        item0 = Int(player.itemId0 ?? 0)
        item1 = Int(player.itemId1 ?? 0)
        item2 = Int(player.itemId2 ?? 0)
        item3 = Int(player.itemId3 ?? 0)
        item4 = Int(player.itemId4 ?? 0)
        item5 = Int(player.itemId5 ?? 0)
        
        kills = player.numKills ?? 0
        deaths = player.numDeaths ?? 0
        assists = player.numAssists ?? 0
        lastHits = Int(player.numLastHits ?? 0)
        denies = Int(player.numDenies ?? 0)
        
        gpm = Int(player.goldPerMinute ?? 0)
        netWorth = player.networth
        xpm = Int(player.experiencePerMinute ?? 0)
        
        heroDamage = player.heroDamage
        heroID = Int(player.heroId ?? 0)
        level = player.level ?? 0
        
        personaname = player.steamAccount?.proSteamAccount?.name ?? player.steamAccount?.name
        rank = player.steamAccount?.seasonRank
        
        positionX = player.playbackData?.positionEvents?.first??.x
        positionY = player.playbackData?.positionEvents?.first??.y
        
        killEvents = player.playbackData?.killEvents?.compactMap({ $0 }).map{ $0.time }
        deathEvents = player.playbackData?.deathEvents?.compactMap({ $0 }).map{ $0.time }
    }
    
    enum CodingKeys: String, CodingTableKey {
        typealias Root = Player
        static let objectRelationalMapping = TableBinding(CodingKeys.self)
        case accountId = "account_id"
        case slot = "player_slot"
        case abilityUpgrade = "ability_upgrades_arr"
       
        // backpack
        case backpack0 = "backpack_0"
        case backpack1 = "backpack_1"
        case backpack2 = "backpack_2"
        //items
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
    
    func hasScepter() -> Bool {
        if item0 == 108 {
            return true
        } else if item1 == 108 {
            return true
        } else if item2 == 108 {
            return true
        } else if item3 == 108 {
            return true
        } else if item4 == 108 {
            return true
        } else if item5 == 108 {
            return true
        } else {
            guard let buffs = permanentBuffs else {
                return false
            }
            for buff in buffs {
                if buff.buffID == 2 {
                    return true
                }
            }
            return false
        }
    }
    
    func hasShard() -> Bool {
        guard let buffs = permanentBuffs else {
            return false
        }
        for buff in buffs {
            if buff.buffID == 12 {
                return true
            }
        }
        return false
    }
}
