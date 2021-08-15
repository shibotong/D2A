//
//  Hero.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 5/7/21.
//

import Foundation
import UIKit

struct PlayerHero: Identifiable, Decodable {
    var id: String
    var lastPlayed: Int
    var games: Int
    var win: Int
    var withGames: Int
    var withWin: Int
    var againstGames: Int
    var againstWin: Int
    
    enum CodingKeys: String, CodingKey {
        case id = "hero_id"
        case lastPlayed = "last_played"
        case games
        case win
        case withGames = "with_games"
        case withWin = "with_win"
        case againstGames = "against_games"
        case againstWin = "against_win"
    }
    
    static var sampleHeroes: [PlayerHero] = loadHeroes()!
    
    func fetchWinRate() -> Double {
        if games == 0 {
            return 0
        }
        return Double(win) / Double(games)
    }
}

class Hero: Identifiable, Decodable {
    // {"id":1,"name":"npc_dota_hero_antimage","localized_name":"Anti-Mage","primary_attr":"agi","attack_type":"Melee","roles":["Carry","Escape","Nuker"],"img":"/apps/dota2/images/heroes/antimage_full.png?","icon":"/apps/dota2/images/heroes/antimage_icon.png","base_health":200,"base_health_regen":0.25,"base_mana":75,"base_mana_regen":0,"base_armor":0,"base_mr":25,"base_attack_min":29,"base_attack_max":33,"base_str":23,"base_agi":24,"base_int":12,"str_gain":1.3,"agi_gain":2.8,"int_gain":1.8,"attack_range":150,"projectile_speed":0,"attack_rate":1.4,"move_speed":310,"turn_rate":null,"cm_enabled":true,"legs":2,"hero_id":1,"turbo_picks":138963,"turbo_wins":70463,"pro_win":21,"pro_pick":43,"pro_ban":150,"1_pick":20602,"1_win":10273,"2_pick":39378,"2_win":19774,"3_pick":50537,"3_win":25419,"4_pick":45104,"4_win":22635,"5_pick":27445,"5_win":13660,"6_pick":12033,"6_win":6033,"7_pick":5041,"7_win":2429,"8_pick":1399,"8_win":689,"null_pick":2029689,"null_win":0}
    var id: Int
    var name: String
    var localizedName: String
    var primaryAttr: String
    var attackType: String
    var roles: [String]
    var legs: Int
    var img: String
    var icon: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case localizedName = "localized_name"
        case primaryAttr = "primary_attr"
        case attackType = "attack_type"
        case roles
        case legs
        case img
        case icon
    }
    
}

