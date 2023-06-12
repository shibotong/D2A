//
//  PlayerRowViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 12/6/2023.
//

import Foundation

class PlayerRowViewModel: ObservableObject {
    
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
}
