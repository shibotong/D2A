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
    
    @Published var accountID: String?
    
    @Published var heroID: Int
    @Published var level: Int
    @Published var personaname: String?
    @Published var rank: Int
    
    @Published var kills: Int
    @Published var deaths: Int
    @Published var assists: Int
    
    @Published var itemNeutral: Int?
    @Published var item0: Int
    @Published var item1: Int
    @Published var item2: Int
    @Published var item3: Int
    @Published var item4: Int
    @Published var item5: Int
    @Published var backpack0: Int?
    @Published var backpack1: Int?
    @Published var backpack2: Int?
    
    @Published var hasScepter: Bool
    @Published var hasShard: Bool
    
    @Published var abilityUpgrade: [Int] = []
    @Published var xpm: Int
    @Published var gpm: Int
    @Published var heroDamage: Int?
    
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
    }
}
