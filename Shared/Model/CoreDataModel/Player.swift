//
//  Player.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import Foundation
import CoreData

extension Player {
    static func create(_ player: PlayerCodable) -> Player {
        let viewContext = PersistenceController.shared.container.viewContext
        let newPlayer = Player(context: viewContext)
        newPlayer.update(player)
        return newPlayer
    }
    
    func update(_ player: PlayerCodable) {
        let viewContext = PersistenceController.shared.container.viewContext
        print(Thread.isMainThread)
        if let accountId = player.accountId {
            self.accountId = Int64(accountId)
        }
        if let persona = player.personaname {
            self.personaname = persona
        }
        if let rank = player.rank {
            self.rank = Int16(rank)
        }
        
        // hero data
        self.heroID = Int16(player.heroID)
        self.level = Int16(player.level)
        self.slot = Int16(player.slot)
        
        // items
        self.item0 = Int16(player.item0)
        self.item1 = Int16(player.item1)
        self.item2 = Int16(player.item2)
        self.item3 = Int16(player.item3)
        self.item4 = Int16(player.item4)
        self.item5 = Int16(player.item5)
        if let backpack0 = player.backpack0,
           let backpack1 = player.backpack1,
           let backpack2 = player.backpack2 {
            self.backpack0 = Int16(backpack0)
            self.backpack1 = Int16(backpack1)
            self.backpack2 = Int16(backpack2)
        }
        if let itemNeutral = player.itemNeutral {
            self.itemNeutral = Int16(itemNeutral)
        }
        
        // KDA
        self.kills = Int16(player.kills)
        self.deaths = Int16(player.deaths)
        self.assists = Int16(player.assists)
        
        self.denies = Int16(player.denies)
        self.lastHits = Int16(player.lastHits)
        
        // finance
        self.gpm = Int16(player.gpm)
        self.xpm = Int16(player.xpm)
        if let towerDamage = player.towerDamage {
            self.towerDamage = Int32(towerDamage)
        }
        if let netWorth = player.netWorth {
            self.netWorth = Int32(netWorth)
        }
        if let heroDamage = player.heroDamage {
            self.heroDamage = Int32(heroDamage)
        }
        if let heroHealing = player.heroHealing {
            self.heroHealing = Int32(heroHealing)
        }
        if let abilityUpgrade = player.abilityUpgrade {
            self.abilityUpgrade = abilityUpgrade as [NSNumber]
        }
        
        if let buffs = self.permanentBuffs?.allObjects as? [PermanentBuff] {
            player.permanentBuffs?.forEach { buffCodable in
                if let existBuff = buffs.first (where: { buff in
                    return buff.buffID == buffCodable.buffID
                }) {
                    existBuff.update(buffCodable)
                } else {
                    let newBuff = PermanentBuff.create(buffCodable)
                    self.addToPermanentBuffs(newBuff)
                }
            }
        }
    }
    
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
            guard let buffs = permanentBuffs?.allObjects as? [PermanentBuff] else {
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
    
    var hasShard: Bool {
        guard let buffs = permanentBuffs?.allObjects as? [PermanentBuff] else {
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


