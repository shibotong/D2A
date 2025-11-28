//
//  Hero+Mappable.swift
//  D2A
//
//  Created by Shibo Tong on 28/11/2025.
//

extension Hero: Mappable {
    func map(json: [String: Any]) {
        guard let id = json[CodingKeys.id.rawValue] as? Int,
              let name = json[CodingKeys.name.rawValue] as? String,
              let primaryAttr = json[CodingKeys.primaryAttr.rawValue] as? String,
              let attackType = json[CodingKeys.attackType.rawValue] as? String,
              let baseHealth = json[CodingKeys.baseHealth.rawValue] as? Int,
              let baseHealthRegen = json[CodingKeys.baseHealthRegen.rawValue] as? Double,
              let baseMana = json[CodingKeys.baseMana.rawValue] as? Int,
              let baseManaRegen = json[CodingKeys.baseManaRegen.rawValue] as? Double,
              let baseArmor = json[CodingKeys.baseArmor.rawValue] as? Double,
              let baseMr = json[CodingKeys.baseMr.rawValue] as? Int,
              let baseAttackMin = json[CodingKeys.baseAttackMin.rawValue] as? Int,
              let baseAttackMax = json[CodingKeys.baseAttackMax.rawValue] as? Int,
              let baseStr = json[CodingKeys.baseStr.rawValue] as? Int,
              let baseAgi = json[CodingKeys.baseAgi.rawValue] as? Int,
              let baseInt = json[CodingKeys.baseInt.rawValue] as? Int,
              let strGain = json[CodingKeys.strGain.rawValue] as? Double,
              let agiGain = json[CodingKeys.agiGain.rawValue] as? Double,
              let intGain = json[CodingKeys.intGain.rawValue] as? Double,
              let attackRange = json[CodingKeys.attackRange.rawValue] as? Int,
              let projectileSpeed = json[CodingKeys.projectileSpeed.rawValue] as? Int,
              let attackRate = json[CodingKeys.attackRate.rawValue] as? Double,
              let moveSpeed = json[CodingKeys.moveSpeed.rawValue] as? Int,
              let cmEnabled = json[CodingKeys.cmEnabled.rawValue] as? Bool else {
            logger.error("Not able to find data when mapping hero")
            return
        }
        
        let turnRate = json[CodingKeys.turnRate.rawValue] as? Double ?? 0.6
    }
    
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
        
        case dayVision = "day_vision"
        case nightVision = "night_vision"
    }
}
