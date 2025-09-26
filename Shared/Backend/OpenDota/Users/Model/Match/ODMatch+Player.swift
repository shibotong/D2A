//
//  ODMatch+Player.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import Foundation
extension ODMatch {
    struct Player: Decodable {
        let playerSlot: Int?
        let abilityUpgrades: [Int]
        
        let accountID: Int
        let assists: Int
        let backpack0: Int
        let backpack1: Int
        let backpack2: Int
        let buyback: [BuyBack]
        
        let campsStacked: Int
        let creepsStacked: Int
        let deaths: Int
        let denies: Int
        let gold: Int
        let gpm: Int
        let goldTime: [Int]
        let heroDamage: Int
        let heroHealing: Int
        let heroID: Int
        let item0: Int
        let item1: Int
        let item2: Int
        let item3: Int
        let item4: Int
        let item5: Int
        let kills: Int
        let killLog: [KillLog]
        let lastHits: Int
        let leaverStatus: Int
        let level: Int
        
        ///Total number of observer wards placed
        let observerPlaced: Int
        
        let permanentBuffs: [PermanentBuff]
        let heroVariant: Int
        let pings: Int
        let purchaseLog: [PurchaseLog]
        let runePickup: Int
        let runeLog: [RuneLog]
        
        let sentryPlaced: Int
        let towerDamange: Int
        let xpm: Int
        let personaname: String?
        
        let name: String?
        let isRadiant: Bool
        let rank: Int
        
        enum CodingKeys: CodingKey {
            case playerSlot
            case abilityUpgrades
            case accountID
            case assists
            case backpack0
            case backpack1
            case backpack2
            case buyback
            case campsStacked
            case creepsStacked
            case deaths
            case denies
            case gold
            case gpm
            case goldTime
            case heroDamage
            case heroHealing
            case heroID
            case item0
            case item1
            case item2
            case item3
            case item4
            case item5
            case kills
            case killLog
            case lastHits
            case leaverStatus
            case level
            case observerPlaced
            case permanentBuffs
            case heroVariant
            case pings
            case purchaseLog
            case runePickup
            case runeLog
            case sentryPlaced
            case towerDamange
            case xpm
            case personaname
            case name
            case isRadiant
            case rank
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ODMatch.Player.CodingKeys> = try decoder.container(keyedBy: ODMatch.Player.CodingKeys.self)
            self.playerSlot = try container.decodeIfPresent(Int.self, forKey: ODMatch.Player.CodingKeys.playerSlot)
            self.abilityUpgrades = try container.decode([Int].self, forKey: ODMatch.Player.CodingKeys.abilityUpgrades)
            self.accountID = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.accountID)
            self.assists = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.assists)
            self.backpack0 = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.backpack0)
            self.backpack1 = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.backpack1)
            self.backpack2 = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.backpack2)
            self.buyback = try container.decode([ODMatch.Player.BuyBack].self, forKey: ODMatch.Player.CodingKeys.buyback)
            self.campsStacked = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.campsStacked)
            self.creepsStacked = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.creepsStacked)
            self.deaths = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.deaths)
            self.denies = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.denies)
            self.gold = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.gold)
            self.gpm = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.gpm)
            self.goldTime = try container.decode([Int].self, forKey: ODMatch.Player.CodingKeys.goldTime)
            self.heroDamage = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.heroDamage)
            self.heroHealing = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.heroHealing)
            self.heroID = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.heroID)
            self.item0 = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.item0)
            self.item1 = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.item1)
            self.item2 = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.item2)
            self.item3 = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.item3)
            self.item4 = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.item4)
            self.item5 = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.item5)
            self.kills = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.kills)
            self.killLog = try container.decode([ODMatch.Player.KillLog].self, forKey: ODMatch.Player.CodingKeys.killLog)
            self.lastHits = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.lastHits)
            self.leaverStatus = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.leaverStatus)
            self.level = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.level)
            self.observerPlaced = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.observerPlaced)
            self.permanentBuffs = try container.decode([ODMatch.Player.PermanentBuff].self, forKey: ODMatch.Player.CodingKeys.permanentBuffs)
            self.heroVariant = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.heroVariant)
            self.pings = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.pings)
            self.purchaseLog = try container.decode([ODMatch.Player.PurchaseLog].self, forKey: ODMatch.Player.CodingKeys.purchaseLog)
            self.runePickup = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.runePickup)
            self.runeLog = try container.decode([ODMatch.Player.RuneLog].self, forKey: ODMatch.Player.CodingKeys.runeLog)
            self.sentryPlaced = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.sentryPlaced)
            self.towerDamange = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.towerDamange)
            self.xpm = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.xpm)
            self.personaname = try container.decodeIfPresent(String.self, forKey: ODMatch.Player.CodingKeys.personaname)
            self.name = try container.decodeIfPresent(String.self, forKey: ODMatch.Player.CodingKeys.name)
            self.isRadiant = try container.decode(Bool.self, forKey: ODMatch.Player.CodingKeys.isRadiant)
            self.rank = try container.decode(Int.self, forKey: ODMatch.Player.CodingKeys.rank)
        }
    }
}
