//
//  Hero.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 5/7/21.
//

import Foundation
import UIKit

class Hero: Identifiable, Decodable {
    var id: Int
    var name: String
    var localizedName: String
    var primaryAttr: String
    var attackType: String
    var roles: [String]
    var legs: Int
    var img: String
    var icon: String
    
    var baseHealth: Int
    var baseHealthRegen: Double
    var baseMana: Int
    var baseManaRegen: Double
    var baseArmor: Double
    var baseMr: Int
    var baseAttackMin: Int
    var baseAttackMax: Int
    var baseStr: Int
    var baseAgi: Int
    var baseInt: Int
    var strGain: Double
    var agiGain: Double
    var intGain: Double
    
    var attackRange: Int
    var projectileSpeed: Int
    var attackRate: Double
    var moveSpeed: Int
    var cmEnabled: Bool
    var turnRate: Double?
    
    let strMaxHP = 20
    let strHPRegen = 0.1
    
    let agiArmor = 0.16666666666666667
    let agiAttackSpeed = 1
    
    let intMaxMP = 12
    let intManaRegen = 0.05

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
    
    func calculateHP() -> Int {
        let hp = self.baseHealth + self.baseStr * self.strMaxHP
        return hp
    }
    func calculateHPRegen() -> Double {
        let regen = self.baseHealthRegen + Double(self.baseStr) * self.strHPRegen
        return regen
    }
    
    func calculateMP() -> Int {
        let mp = self.baseMana + self.baseInt * self.intMaxMP
        return mp
    }
    func calculateMPRegen() -> Double {
        let regen = self.baseManaRegen + Double(self.baseInt) * self.intManaRegen
        return regen
    }
    
    func calculateAttack(attack: Int) -> Int {
        let mainAttributes = self.getMainAttributes()
        return attack + mainAttributes
    }
    
    func calculateArmor() -> Double {
        let armor = self.baseArmor + self.agiArmor * Double(self.baseAgi)
        return armor
    }
    
    private func getMainAttributes() -> Int {
        switch self.primaryAttr {
        case "str":
            return self.baseStr
        case "agi":
            return self.baseAgi
        case "int":
            return self.baseInt
        default:
            return 0
        }
    }
}

class HeroAbility: Decodable {
    var abilities: [String]
    var talents: [Talent]
}

struct Talent: Decodable {
    var name: String
    var level: Int
}

