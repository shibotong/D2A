//
//  HeroCodable.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 5/7/21.
//

import Foundation
import UIKit

class HeroCodable: Identifiable, Decodable {
    var heroID: Int
    var name: String
    var localizedName: String
    var primaryAttr: String
    var attackType: String
    var legs: Int?
    
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
        case heroID = "id"
        case name
        case localizedName = "localized_name"
        case primaryAttr = "primary_attr"
        case attackType = "attack_type"
        case roles
        case legs
        
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
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.heroID = try container.decode(Int.self, forKey: .heroID)
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.localizedName = (try? container.decode(String.self, forKey: .localizedName)) ?? ""
        self.primaryAttr = (try? container.decode(String.self, forKey: .primaryAttr)) ?? ""
        self.attackType = (try? container.decode(String.self, forKey: .attackType)) ?? ""
        self.legs = (try? container.decodeIfPresent(Int.self, forKey: .legs)) ?? 0
        self.baseHealth = (try? container.decode(Int32.self, forKey: .baseHealth)) ?? 0
        self.baseHealthRegen = (try? container.decode(Double.self, forKey: .baseHealthRegen)) ?? 0
        self.baseMana = (try? container.decode(Int32.self, forKey: .baseMana)) ?? 0
        self.baseManaRegen = (try? container.decode(Double.self, forKey: .baseManaRegen)) ?? 0
        self.baseArmor = (try? container.decode(Double.self, forKey: .baseArmor)) ?? 0
        self.baseMr = (try? container.decode(Int32.self, forKey: .baseMr)) ?? 0
        self.baseAttackMin = (try? container.decode(Int32.self, forKey: .baseAttackMin)) ?? 0
        self.baseAttackMax = (try? container.decode(Int32.self, forKey: .baseAttackMax)) ?? 0
        self.baseStr = (try? container.decode(Int32.self, forKey: .baseStr)) ?? 0
        self.baseAgi = (try? container.decode(Int32.self, forKey: .baseAgi)) ?? 0
        self.baseInt = (try? container.decode(Int32.self, forKey: .baseInt)) ?? 0
        self.strGain = (try? container.decode(Double.self, forKey: .strGain)) ?? 0
        self.agiGain = (try? container.decode(Double.self, forKey: .agiGain)) ?? 0
        self.intGain = (try? container.decode(Double.self, forKey: .intGain)) ?? 0
        self.attackRange = (try? container.decode(Int32.self, forKey: .attackRange)) ?? 0
        self.projectileSpeed = (try? container.decode(Int32.self, forKey: .projectileSpeed)) ?? 0
        self.attackRate = (try? container.decode(Double.self, forKey: .attackRate)) ?? 0
        self.moveSpeed = (try? container.decode(Int32.self, forKey: .moveSpeed)) ?? 0
        self.cmEnabled = (try? container.decode(Bool.self, forKey: .cmEnabled)) ?? false
        self.turnRate = try? container.decodeIfPresent(Double.self, forKey: .turnRate)
    }
    
    init(heroID: Int = 0, name: String = "", localizedName: String = "", primaryAttr: String = "", attackType: String = "", legs: Int = 0, baseHealth: Int32 = 0, baseHealthRegen: Double = 0, baseMana: Int32 = 0, baseManaRegen: Double = 0, baseArmor: Double = 0, baseMr: Int32 = 0, baseAttackMin: Int32 = 0, baseAttackMax: Int32 = 0, baseStr: Int32 = 0, baseAgi: Int32 = 0, baseInt: Int32 = 0, strGain: Double = 0, agiGain: Double = 0, intGain: Double = 0, attackRange: Int32 = 0, projectileSpeed: Int32 = 0, attackRate: Double = 0, moveSpeed: Int32 = 0, cmEnabled: Bool = false, turnRate: Double = 0) {
        self.heroID = heroID
        self.name = name
        self.localizedName = localizedName
        self.primaryAttr = primaryAttr
        self.attackType = attackType
        self.legs = legs
        self.baseHealth = baseHealth
        self.baseHealthRegen = baseHealthRegen
        self.baseMana = baseMana
        self.baseManaRegen = baseManaRegen
        self.baseArmor = baseArmor
        self.baseMr = baseMr
        self.baseAttackMin = baseAttackMin
        self.baseAttackMax = baseAttackMax
        self.baseStr = baseStr
        self.baseAgi = baseAgi
        self.baseInt = baseInt
        self.strGain = strGain
        self.agiGain = agiGain
        self.intGain = intGain
        self.attackRange = attackRange
        self.projectileSpeed = projectileSpeed
        self.attackRate = attackRate
        self.moveSpeed = moveSpeed
        self.cmEnabled = cmEnabled
        self.turnRate = turnRate
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
