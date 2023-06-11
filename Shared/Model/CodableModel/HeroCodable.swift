//
//  HeroCodable.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 5/7/21.
//

import Foundation
import UIKit

class HeroCodable: Identifiable, Decodable {
    var id: Int
    var name: String
    var localizedName: String
    var primaryAttr: String
    var attackType: String
    var roles: [String]
    var legs: Int
    var img: String
    var icon: String
    
    var baseHealth: Int32
    var baseHealthRegen: Double
    var baseMana: Int32
    var baseManaRegen: Double
    var baseArmor: Double
    var baseMr: Int32
    var baseAttackMin: Int32
    var baseAttackMax: Int32
    var baseStr: Int32
    var baseAgi: Int32
    var baseInt: Int32
    var strGain: Double
    var agiGain: Double
    var intGain: Double
    
    var attackRange: Int32
    var projectileSpeed: Int32
    var attackRate: Double
    var moveSpeed: Int32
    var cmEnabled: Bool
    var turnRate: Double?
    
    var heroNameLowerCase: String {
        return name.replacingOccurrences(of: "npc_dota_hero_", with: "")
    }

    var heroNameLocalized: String {
        return NSLocalizedString(localizedName, comment: "")
    }
    
    static let strMaxHP: Int32 = 20
    static let strHPRegen = 0.1
    
    static let agiArmor = 0.16666666666666667
    static let agiAttackSpeed: Int32 = 1
    
    static let intMaxMP: Int32 = 12
    static let intManaRegen = 0.05

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
        
        case baseHealth = "base_health"
        case baseHealthRegen = "base_health_regen"
        case baseMana = "base_mana"
        case baseManaRegen = "base_mana_regen"
        case baseArmor = "base_armor"
        case baseMr = "base_mr"
        case baseAttackMin = "base_attack_min"
        case baseAttackMax = "base_attack_max"
        case baseStr = "base_str"
        case baseAgi = "base_agi"
        case baseInt = "base_int"
        case strGain = "str_gain"
        case agiGain = "agi_gain"
        case intGain = "int_gain"
        
        case attackRange = "attack_range"
        case projectileSpeed = "projectile_speed"
        case attackRate = "attack_rate"
        case moveSpeed = "move_speed"
        case cmEnabled = "cm_enabled"
        case turnRate = "turn_rate"
    }
}

class HeroAbility: Decodable {
    var abilities: [String]
}

struct HeroScepter: Decodable {
    var name: String
    var id: Int
    var scepterDesc: String
    var scepterSkillName: String
    var scepterNewSkill: Bool
    var shardDesc: String
    var shardSkillName: String
    var shardNewSkill: Bool
    
    enum CodingKeys: String, CodingKey {
        case name = "hero_name"
        case id = "hero_id"
        case scepterDesc = "scepter_desc"
        case scepterSkillName = "scepter_skill_name"
        case scepterNewSkill = "scepter_new_skill"
        case shardDesc = "shard_desc"
        case shardSkillName = "shard_skill_name"
        case shardNewSkill = "shard_new_skill"
    }
}
