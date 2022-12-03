//
//  Player.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import Foundation
import CoreData

class Player: NSObject, NSSecureCoding {
    
    static let supportsSecureCoding: Bool = true
    
    let accountId: String?
    let personaname: String?
    let rank: Int
    
    // hero data
    let heroID: Int
    let level: Int
    let slot: Int
    
    // items
    let item0: Int
    let item1: Int
    let item2: Int
    let item3: Int
    let item4: Int
    let item5: Int
    let backpack0: Int?
    let backpack1: Int?
    let backpack2: Int?
    let itemNeutral: Int?
    
    // KDA
    let kills: Int
    let deaths: Int
    let assists: Int
    
    let denies: Int
    let lastHits: Int
    
    // finance
    let gpm: Int
    let xpm: Int
    let towerDamage: Int?
    let netWorth: Int?
    let heroDamage: Int?
    let heroHealing: Int?
    var abilityUpgrade: [Int] = []
    
    var permanentBuffs: [PermanentBuff] = []
    
    var hasScepter: Bool {
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
            let buffs = permanentBuffs
            for buff in buffs {
                if buff.buffID == 2 {
                    return true
                }
            }
            return false
        }
    }
    
    var hasShard: Bool {
        let buffs = permanentBuffs
        for buff in buffs {
            if buff.buffID == 12 {
                return true
            }
        }
        return false
    }
    
    init(player: PlayerCodable) {
        self.accountId = player.accountId?.description
        self.personaname = player.personaname
        self.rank = player.rank ?? 0
        
        
        // hero data
        self.heroID = player.heroID
        self.level = player.level
        self.slot = player.slot
        
        // items
        self.item0 = player.item0
        self.item1 = player.item1
        self.item2 = player.item2
        self.item3 = player.item3
        self.item4 = player.item4
        self.item5 = player.item5
        self.backpack0 = player.backpack0
        self.backpack1 = player.backpack1
        self.backpack2 = player.backpack2
        self.itemNeutral = player.itemNeutral
        
        
        // KDA
        self.kills = player.kills
        self.deaths = player.deaths
        self.assists = player.assists
        
        self.denies = player.denies
        self.lastHits = player.lastHits
        
        // finance
        self.gpm = player.gpm
        self.xpm = player.xpm
        self.towerDamage = player.towerDamage
        self.netWorth = player.netWorth
        self.heroDamage = player.heroDamage
        self.heroHealing = player.heroHealing
        
        if let abilityUpgrade = player.abilityUpgrade {
            self.abilityUpgrade = abilityUpgrade as [Int]
        }
        if let buffs = player.permanentBuffs {
            self.permanentBuffs = buffs.map { PermanentBuff($0) }
        }
        
    }
    
    enum CodingKeys: String, CodingKey {
        case accountId
        case slot
        case abilityUpgrade
       
        // backpack
        case backpack0
        case backpack1
        case backpack2
        //items
        case item0
        case item1
        case item2
        case item3
        case item4
        case item5
        case itemNeutral
        // KDA
        case deaths
        case denies
        case assists
        case kills
        case lastHits

        case gpm
        case gold_t
        case xpm
        case xp_t
        case netWorth

        case heroDamage
        case heroHealing
        case heroID
        case level

        case permanentBuffs
        case teamFightParticipation
        case towerDamage

        case personaname
        case multiKills
        
        case rank
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(accountId, forKey: CodingKeys.accountId.rawValue)
        coder.encode(personaname, forKey: CodingKeys.personaname.rawValue)
        coder.encode(rank, forKey: CodingKeys.rank.rawValue)
        coder.encode(heroID, forKey: CodingKeys.heroID.rawValue)
        coder.encode(level, forKey: CodingKeys.level.rawValue)
        coder.encode(slot, forKey: CodingKeys.slot.rawValue)
        coder.encode(item0, forKey: CodingKeys.item0.rawValue)
        coder.encode(item1, forKey: CodingKeys.item1.rawValue)
        coder.encode(item2, forKey: CodingKeys.item2.rawValue)
        coder.encode(item3, forKey: CodingKeys.item3.rawValue)
        coder.encode(item4, forKey: CodingKeys.item4.rawValue)
        coder.encode(item5, forKey: CodingKeys.item5.rawValue)
        coder.encode(backpack0, forKey: CodingKeys.backpack0.rawValue)
        coder.encode(backpack1, forKey: CodingKeys.backpack1.rawValue)
        coder.encode(backpack2, forKey: CodingKeys.backpack2.rawValue)
        coder.encode(itemNeutral, forKey: CodingKeys.itemNeutral.rawValue)
        coder.encode(kills, forKey: CodingKeys.kills.rawValue)
        coder.encode(deaths, forKey: CodingKeys.deaths.rawValue)
        coder.encode(assists, forKey: CodingKeys.assists.rawValue)
        coder.encode(denies, forKey: CodingKeys.denies.rawValue)
        coder.encode(lastHits, forKey: CodingKeys.lastHits.rawValue)
        coder.encode(gpm, forKey: CodingKeys.gpm.rawValue)
        coder.encode(xpm, forKey: CodingKeys.xpm.rawValue)
        coder.encode(towerDamage, forKey: CodingKeys.towerDamage.rawValue)
        coder.encode(netWorth, forKey: CodingKeys.netWorth.rawValue)
        coder.encode(heroDamage, forKey: CodingKeys.heroDamage.rawValue)
        coder.encode(heroHealing, forKey: CodingKeys.heroHealing.rawValue)
        coder.encode(abilityUpgrade, forKey: CodingKeys.abilityUpgrade.rawValue)
        coder.encode(permanentBuffs, forKey: CodingKeys.permanentBuffs.rawValue)
    }
    
    required init?(coder: NSCoder) {
        guard let abilityUpgrade = coder.decodeArrayOfObjects(ofClass: NSNumber.self, forKey: CodingKeys.abilityUpgrade.rawValue) as? [Int],
              let permanentBuffs = coder.decodeArrayOfObjects(ofClass: PermanentBuff.self, forKey: CodingKeys.permanentBuffs.rawValue) else {
                  return nil
        }
        self.accountId = coder.decodeObject(of: NSString.self, forKey: CodingKeys.accountId.rawValue) as? String
        self.personaname = coder.decodeObject(of: NSString.self, forKey: CodingKeys.personaname.rawValue) as? String
        self.rank = coder.decodeInteger(forKey: CodingKeys.rank.rawValue)
        
        self.heroID = coder.decodeInteger(forKey: CodingKeys.heroID.rawValue)
        self.level = coder.decodeInteger(forKey: CodingKeys.level.rawValue)
        self.slot = coder.decodeInteger(forKey: CodingKeys.slot.rawValue)
        
        self.item0 = coder.decodeInteger(forKey: CodingKeys.item0.rawValue)
        self.item1 = coder.decodeInteger(forKey: CodingKeys.item1.rawValue)
        self.item2 = coder.decodeInteger(forKey: CodingKeys.item2.rawValue)
        self.item3 = coder.decodeInteger(forKey: CodingKeys.item3.rawValue)
        self.item4 = coder.decodeInteger(forKey: CodingKeys.item4.rawValue)
        self.item5 = coder.decodeInteger(forKey: CodingKeys.item5.rawValue)
        self.backpack0 = coder.decodeObject(forKey: CodingKeys.backpack0.rawValue) as? Int
        self.backpack1 = coder.decodeObject(forKey: CodingKeys.backpack1.rawValue) as? Int
        self.backpack2 = coder.decodeObject(forKey: CodingKeys.backpack2.rawValue) as? Int
        self.itemNeutral = coder.decodeObject(forKey: CodingKeys.itemNeutral.rawValue) as? Int
        
        self.kills = coder.decodeInteger(forKey: CodingKeys.kills.rawValue)
        self.deaths = coder.decodeInteger(forKey: CodingKeys.deaths.rawValue)
        self.assists = coder.decodeInteger(forKey: CodingKeys.assists.rawValue)
        self.denies = coder.decodeInteger(forKey: CodingKeys.denies.rawValue)
        self.lastHits = coder.decodeInteger(forKey: CodingKeys.lastHits.rawValue)
        
        self.gpm = coder.decodeInteger(forKey: CodingKeys.gpm.rawValue)
        self.xpm = coder.decodeInteger(forKey: CodingKeys.xpm.rawValue)
        self.towerDamage = coder.decodeObject(forKey: CodingKeys.towerDamage.rawValue) as? Int
        self.netWorth = coder.decodeObject(forKey: CodingKeys.netWorth.rawValue) as? Int
        self.heroDamage = coder.decodeObject(forKey: CodingKeys.heroDamage.rawValue) as? Int
        self.heroHealing = coder.decodeObject(forKey: CodingKeys.heroHealing.rawValue) as? Int
        
        self.abilityUpgrade = abilityUpgrade
        self.permanentBuffs = permanentBuffs
    }
}


