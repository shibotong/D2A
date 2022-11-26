//
//  Player.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import Foundation

extension Player {
    static func create(_ player: PlayerCodable) -> Player {
        let viewContext = PersistenceController.shared.container.viewContext
        let newPlayer = Player(context: viewContext)
        newPlayer.id = UUID()
        if let accountId = player.accountId {
            newPlayer.accountId = Int32(accountId)
        }
        if let persona = player.personaname {
            newPlayer.personaname = persona
        }
        if let rank = player.rank {
            newPlayer.rank = Int16(rank)
        }
        
        // hero data
        newPlayer.heroID = Int16(player.heroID)
        newPlayer.level = Int16(player.level)
        newPlayer.slot = Int16(player.slot)
        
        // items
        newPlayer.item0 = Int16(player.item0)
        newPlayer.item1 = Int16(player.item1)
        newPlayer.item2 = Int16(player.item2)
        newPlayer.item3 = Int16(player.item3)
        newPlayer.item4 = Int16(player.item4)
        newPlayer.item5 = Int16(player.item5)
        if let backpack0 = player.backpack0,
           let backpack1 = player.backpack1,
           let backpack2 = player.backpack2 {
            newPlayer.backpack0 = Int16(backpack0)
            newPlayer.backpack1 = Int16(backpack1)
            newPlayer.backpack2 = Int16(backpack2)
        }
        if let itemNeutral = player.itemNeutral {
            newPlayer.itemNeutral = Int16(itemNeutral)
        }
        
        // KDA
        newPlayer.kills = Int16(player.kills)
        newPlayer.deaths = Int16(player.deaths)
        newPlayer.assists = Int16(player.assists)
        
        newPlayer.denies = Int16(player.denies)
        newPlayer.lastHits = Int16(player.lastHits)
        
        // finance
        newPlayer.gpm = Int16(player.gpm)
        newPlayer.xpm = Int16(player.xpm)
        if let towerDamage = player.towerDamage {
            newPlayer.towerDamage = Int32(towerDamage)
        }
        if let netWorth = player.netWorth {
            newPlayer.netWorth = Int32(netWorth)
        }
        if let heroDamage = player.heroDamage {
            newPlayer.heroDamage = Int32(heroDamage)
        }
        if let heroHealing = player.heroHealing {
            newPlayer.heroHealing = Int32(heroHealing)
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return newPlayer
    }
}
