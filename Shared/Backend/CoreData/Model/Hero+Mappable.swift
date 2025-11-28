//
//  Hero+Mappable.swift
//  D2A
//
//  Created by Shibo Tong on 28/11/2025.
//

extension Hero: Mappable {
    func map(json: [String: Any]) {
        guard let id = json[CodingKeys.id.rawValue] as? Int else {
            logger.error("Not able to find id when mapping hero")
            return
        }
        if let name = json[CodingKeys.name.rawValue] as? String {
            setIfNotEqual(entity: self, path: \.name, value: name)
        }
        if let primaryAttr = json[CodingKeys.primaryAttr.rawValue] as? String {
            setIfNotEqual(entity: self, path: \.primaryAttr, value: primaryAttr)
        }
        if let attackType = json[CodingKeys.attackType.rawValue] as? String {
            setIfNotEqual(entity: self, path: \.attackType, value: attackType)
        }
        if let baseHealth = json[CodingKeys.baseHealth.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.baseHealth, value: Int32(baseHealth))
        }
        if let baseHealthRegen = json[CodingKeys.baseHealthRegen.rawValue] as? Double {
            setIfNotEqual(entity: self, path: \.baseHealthRegen, value: baseHealthRegen)
        }
        if let baseMana = json[CodingKeys.baseMana.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.baseMana, value: Int32(baseMana))
        }
        if let baseManaRegen = json[CodingKeys.baseManaRegen.rawValue] as? Double {
            setIfNotEqual(entity: self, path: \.baseManaRegen, value: baseManaRegen)
        }
        if let baseArmor = json[CodingKeys.baseArmor.rawValue] as? Double {
            setIfNotEqual(entity: self, path: \.baseArmor, value: baseArmor)
        }
        if let baseMr = json[CodingKeys.baseMr.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.baseMr, value: Int32(baseMr))
        }
        if let baseAttackMin = json[CodingKeys.baseAttackMin.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.baseAttackMin, value: Int32(baseAttackMin))
        }
        if let baseAttackMax = json[CodingKeys.baseAttackMax.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.baseAttackMax, value: Int32(baseAttackMax))
        }
        if let baseStr = json[CodingKeys.baseStr.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.baseStr, value: Int32(baseStr))
        }
        if let baseAgi = json[CodingKeys.baseAgi.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.baseAgi, value: Int32(baseAgi))
        }
        if let baseInt = json[CodingKeys.baseInt.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.baseInt, value: Int32(baseInt))
        }
        if let strGain = json[CodingKeys.strGain.rawValue] as? Double {
            setIfNotEqual(entity: self, path: \.gainStr, value: strGain)
        }
        if let agiGain = json[CodingKeys.agiGain.rawValue] as? Double {
            setIfNotEqual(entity: self, path: \.gainAgi, value: agiGain)
        }
        if let intGain = json[CodingKeys.intGain.rawValue] as? Double {
            setIfNotEqual(entity: self, path: \.gainInt, value: intGain)
        }
        if let attackRange = json[CodingKeys.attackRange.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.attackRange, value: Int32(attackRange))
        }
        if let projectileSpeed = json[CodingKeys.projectileSpeed.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.projectileSpeed, value: Int32(projectileSpeed))
        }
        if let attackRate = json[CodingKeys.attackRate.rawValue] as? Double {
            setIfNotEqual(entity: self, path: \.attackRate, value: attackRate)
        }
        if let moveSpeed = json[CodingKeys.moveSpeed.rawValue] as? Int {
            setIfNotEqual(entity: self, path: \.moveSpeed, value: Int32(moveSpeed))
        }
        
        let turnRate = json[CodingKeys.turnRate.rawValue] as? Double ?? 0.6
        setIfNotEqual(entity: self, path: \.id, value: Double(id))
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
        case turnRate = "turn_rate"
        
        case dayVision = "day_vision"
        case nightVision = "night_vision"
    }
}
