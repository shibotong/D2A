//
//  PlayerRowViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 12/6/2023.
//

import Foundation
import StratzAPI

class PlayerRowViewModel: ObservableObject {
    
    typealias LiveMatchPlayer = LiveMatchSubscription.Data.MatchLive.Player
    
    var accountID: String?
    
    var heroID: Int
    var level: Int
    var personaname: String?
    var rank: Int
    
    var kills: Int
    var deaths: Int
    var assists: Int
    
    var itemNeutral: Int?
    @Published var item0: Int?
    @Published var item1: Int?
    @Published var item2: Int?
    @Published var item3: Int?
    @Published var item4: Int?
    @Published var item5: Int?
    @Published var backpack0: Int?
    @Published var backpack1: Int?
    @Published var backpack2: Int?
    
    var hasScepter: Bool
    var hasShard: Bool
    
    var abilityUpgrade: [Int] = []
    var xpm: Int
    var gpm: Int
    var heroDamage: Int?
    
    var slot: Int
    
    var isRadiant: Bool {
        return slot < 127
    }
    
    init(player: Player) {
        self.heroID = player.heroID
        self.level = player.level
        self.personaname = player.personaname
        self.rank = player.rank
        
        self.kills = player.kills
        self.deaths = player.deaths
        self.assists = player.assists
        
        self.itemNeutral = player.itemNeutral
        self.item0 = player.item0
        self.item1 = player.item1
        self.item2 = player.item2
        self.item3 = player.item3
        self.item4 = player.item4
        self.item5 = player.item5
        self.backpack0 = player.backpack0
        self.backpack1 = player.backpack1
        self.backpack2 = player.backpack2
        
        self.hasScepter = player.hasScepter
        self.hasShard = player.hasShard
        self.abilityUpgrade = player.abilityUpgrade
        self.accountID = player.accountId
        
        self.xpm = player.xpm
        self.gpm = player.gpm
        self.heroDamage = player.heroDamage
        
        self.slot = player.slot
    }
    
    init(player: LiveMatchPlayer) {
        let playerName = player.steamAccount?.proSteamAccount?.name ?? player.steamAccount?.name
        if playerName != nil {
            self.accountID = player.steamAccountId?.description
        }
        self.heroID = Int(player.heroId ?? 0)
        self.level = player.level ?? 0
        self.personaname = playerName
        self.rank = player.steamAccount?.seasonRank ?? 0
        self.kills = player.numKills ?? 0
        self.deaths = player.numDeaths ?? 0
        self.assists = player.numAssists ?? 0
        
        self.item0 = Int(player.itemId0 ?? 0)
        self.item1 = Int(player.itemId1 ?? 0)
        self.item2 = Int(player.itemId2 ?? 0)
        self.item3 = Int(player.itemId3 ?? 0)
        self.item4 = Int(player.itemId4 ?? 0)
        self.item5 = Int(player.itemId5 ?? 0)
        self.backpack0 = Int(player.backpackId0 ?? 0)
        self.backpack1 = Int(player.backpackId1 ?? 0)
        self.backpack2 = Int(player.backpackId2 ?? 0)
        
        self.hasScepter = {
            return player.itemId0 == 108 || player.itemId1 == 108 || player.itemId2 == 108 || player.itemId3 == 108 || player.itemId4 == 108 || player.itemId5 == 108
        }()
        
        self.hasShard = false
        self.xpm = Int(player.experiencePerMinute ?? "0") ?? 0
        self.gpm = Int(player.goldPerMinute ?? "0") ?? 0
        self.heroDamage = player.heroDamage
        self.slot = player.playerSlot ?? 0
    }
    
    init(heroID: Int, abilities: [Int] = []) {
        self.personaname = "AME"
        self.heroID = heroID
        self.level = 10
        self.rank = 0
        self.kills = 1
        self.deaths = 1
        self.assists = 1
        self.item0 = 1
        self.item1 = 2
        self.item2 = 3
        self.item3 = 4
        self.item4 = 5
        self.item5 = 6
        self.backpack0 = nil
        self.backpack1 = nil
        self.backpack2 = nil
        
        self.xpm = 100
        self.gpm = 100
        self.heroDamage = 10000
        self.hasScepter = true
        self.hasShard = true
        self.slot = 0
        self.abilityUpgrade = abilities
    }
}
