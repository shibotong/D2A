//
//  Player.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import Foundation
import CoreData

@objc(PlayerTransformer)
final class PlayerTransformer: NSSecureUnarchiveFromDataTransformer {

    // The name of the transformer. This is what we will use to register the transformer `ValueTransformer.setValueTrandformer(_"forName:)`.
    static let name = NSValueTransformerName(rawValue: String(describing: PlayerTransformer.self))

    // Our class `Test` should in the allowed class list. (This is what the unarchiver uses to check for the right class)
    override static var allowedTopLevelClasses: [AnyClass] {
        return [NSArray.self, NSNumber.self, Player.self, PermanentBuff.self]
    }

    /// Registers the transformer.
    public static func register() {
        let transformer = PlayerTransformer()
        ValueTransformer.setValueTransformer(transformer, forName: name)
    }
}

public class Player: NSObject, NSSecureCoding, Identifiable {
    
    public static let supportsSecureCoding: Bool = true
    
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
            return buffs.first { buff in
                buff.buffID == 2
            } != nil
        }
    }
    
    var hasShard: Bool {
        let buffs = permanentBuffs
        return buffs.first { buff in
            buff.buffID == 12
        } != nil
    }
    
    init(id: String,
         slot: Int,
         heroID: Int = 1,
         personaname: String = "Sample Player",
         rank: Int = 0,
         level: Int = 25,
         item: Int = 1) {
        accountId = id
        self.heroID = heroID
        self.slot = slot
        self.rank = rank
        self.level = level
        self.personaname = personaname
        
        item0 = item
        item1 = item
        item2 = item
        item3 = item
        item4 = item
        item5 = item
        backpack0 = item
        backpack1 = item
        backpack2 = item
        itemNeutral = item
        
        kills = 5
        assists = 5
        deaths = 5
        
        denies = 5
        lastHits = 5
        
        gpm = 100
        xpm = 100
        towerDamage = 10000
        heroDamage = 10000
        heroHealing = 10000
        netWorth = 10000
        
        abilityUpgrade = []
    }
    
    init(player: PlayerCodable) {
        accountId = player.accountId?.description
        personaname = player.personaname
        rank = player.rank ?? 0
        
        // hero data
        heroID = player.heroID
        level = player.level
        slot = player.slot
        
        // items
        item0 = player.item0
        item1 = player.item1
        item2 = player.item2
        item3 = player.item3
        item4 = player.item4
        item5 = player.item5
        backpack0 = player.backpack0
        backpack1 = player.backpack1
        backpack2 = player.backpack2
        itemNeutral = player.itemNeutral
        
        // KDA
        kills = player.kills
        deaths = player.deaths
        assists = player.assists
        
        denies = player.denies
        lastHits = player.lastHits
        
        // finance
        gpm = player.gpm
        xpm = player.xpm
        towerDamage = player.towerDamage
        netWorth = player.netWorth
        heroDamage = player.heroDamage
        heroHealing = player.heroHealing
        
        if let abilityUpgrade = player.abilityUpgrade {
            self.abilityUpgrade = abilityUpgrade as [Int]
        }
        if let buffs = player.permanentBuffs {
            permanentBuffs = buffs.map { PermanentBuff($0) }
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
        // items
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
    
    public func encode(with coder: NSCoder) {
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
    
    required public init?(coder: NSCoder) {
        guard let abilityUpgrade = coder.decodeArrayOfObjects(ofClass: NSNumber.self, forKey: CodingKeys.abilityUpgrade.rawValue) as? [Int],
              let permanentBuffs = coder.decodeArrayOfObjects(ofClass: PermanentBuff.self, forKey: CodingKeys.permanentBuffs.rawValue) else {
                  return nil
        }
        accountId = coder.decodeObject(of: NSString.self, forKey: CodingKeys.accountId.rawValue) as? String
        personaname = coder.decodeObject(of: NSString.self, forKey: CodingKeys.personaname.rawValue) as? String
        rank = coder.decodeInteger(forKey: CodingKeys.rank.rawValue)
        
        heroID = coder.decodeInteger(forKey: CodingKeys.heroID.rawValue)
        level = coder.decodeInteger(forKey: CodingKeys.level.rawValue)
        slot = coder.decodeInteger(forKey: CodingKeys.slot.rawValue)
        
        item0 = coder.decodeInteger(forKey: CodingKeys.item0.rawValue)
        item1 = coder.decodeInteger(forKey: CodingKeys.item1.rawValue)
        item2 = coder.decodeInteger(forKey: CodingKeys.item2.rawValue)
        item3 = coder.decodeInteger(forKey: CodingKeys.item3.rawValue)
        item4 = coder.decodeInteger(forKey: CodingKeys.item4.rawValue)
        item5 = coder.decodeInteger(forKey: CodingKeys.item5.rawValue)
        backpack0 = coder.decodeObject(forKey: CodingKeys.backpack0.rawValue) as? Int
        backpack1 = coder.decodeObject(forKey: CodingKeys.backpack1.rawValue) as? Int
        backpack2 = coder.decodeObject(forKey: CodingKeys.backpack2.rawValue) as? Int
        itemNeutral = coder.decodeObject(forKey: CodingKeys.itemNeutral.rawValue) as? Int
        
        kills = coder.decodeInteger(forKey: CodingKeys.kills.rawValue)
        deaths = coder.decodeInteger(forKey: CodingKeys.deaths.rawValue)
        assists = coder.decodeInteger(forKey: CodingKeys.assists.rawValue)
        denies = coder.decodeInteger(forKey: CodingKeys.denies.rawValue)
        lastHits = coder.decodeInteger(forKey: CodingKeys.lastHits.rawValue)
        
        gpm = coder.decodeInteger(forKey: CodingKeys.gpm.rawValue)
        xpm = coder.decodeInteger(forKey: CodingKeys.xpm.rawValue)
        towerDamage = coder.decodeObject(forKey: CodingKeys.towerDamage.rawValue) as? Int
        netWorth = coder.decodeObject(forKey: CodingKeys.netWorth.rawValue) as? Int
        heroDamage = coder.decodeObject(forKey: CodingKeys.heroDamage.rawValue) as? Int
        heroHealing = coder.decodeObject(forKey: CodingKeys.heroHealing.rawValue) as? Int
        
        self.abilityUpgrade = abilityUpgrade
        self.permanentBuffs = permanentBuffs
    }
}
