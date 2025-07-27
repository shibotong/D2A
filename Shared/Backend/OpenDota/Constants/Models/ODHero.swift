//
//  ODHero.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 5/7/21.
//

import CoreData
import Foundation
import UIKit

class ODHero: Identifiable, Decodable, PersistanceModel {

    var id: Int
    var name: String
    var localizedName: String
    var primaryAttr: String
    var attackType: String
    var roles: [String]
    var legs: Int?
    var img: String
    var icon: String
    
    var abilities: [String]

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

    var dictionaries: [String: Any] {
        return [
            "id": Double(id),
            "name": name,
            "displayName": localizedName,
            "primaryAttr": primaryAttr,
            "attackType": attackType,
            "img": img,
            "icon": icon,
            "abilities": abilities,
            "baseHealth": baseHealth,
            "baseHealthRegen": baseHealthRegen,
            "baseMana": baseMana,
            "baseManaRegen": baseManaRegen,
            "baseArmor": baseArmor,
            "baseMr": baseMr,
            "baseAttackMin": baseAttackMin,
            "baseAttackMax": baseAttackMax,
            "baseStr": baseStr,
            "baseAgi": baseAgi,
            "baseInt": baseInt,
            "gainStr": strGain,
            "gainAgi": agiGain,
            "gainInt": intGain,
            "attackRange": attackRange,
            "projectileSpeed": projectileSpeed,
            "attackRate": attackRate,
            "moveSpeed": moveSpeed,
            "turnRate": turnRate ?? 0,
        ]
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
    }

    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)

        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.localizedName = (try? container.decode(String.self, forKey: .localizedName)) ?? ""
        self.primaryAttr = (try? container.decode(String.self, forKey: .primaryAttr)) ?? ""
        self.attackType = (try? container.decode(String.self, forKey: .attackType)) ?? ""
        self.roles = (try? container.decode([String].self, forKey: .roles)) ?? []
        self.legs = (try? container.decodeIfPresent(Int.self, forKey: .legs)) ?? 0
        self.img = (try? container.decode(String.self, forKey: .img)) ?? ""
        self.icon = (try? container.decode(String.self, forKey: .icon)) ?? ""
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
        self.abilities = []
    }

    func update(context: NSManagedObjectContext) throws -> NSManagedObject {
        let hero = Hero.fetch(id: id, context: context) ?? Hero(context: context)
        setIfNotEqual(entity: hero, path: \.id, value: Double(id))
        setIfNotEqual(entity: hero, path: \.displayName, value: localizedName)
        setIfNotEqual(entity: hero, path: \.primaryAttr, value: primaryAttr)
        setIfNotEqual(entity: hero, path: \.attackType, value: attackType)
        setIfNotEqual(entity: hero, path: \.img, value: img)
        setIfNotEqual(entity: hero, path: \.icon, value: icon)
        setIfNotEqual(entity: hero, path: \.abilities, value: abilities)

        setIfNotEqual(entity: hero, path: \.baseHealth, value: baseHealth)
        setIfNotEqual(entity: hero, path: \.baseHealthRegen, value: baseHealthRegen)
        setIfNotEqual(entity: hero, path: \.baseMana, value: baseMana)
        setIfNotEqual(entity: hero, path: \.baseManaRegen, value: baseManaRegen)
        setIfNotEqual(entity: hero, path: \.baseArmor, value: baseArmor)
        setIfNotEqual(entity: hero, path: \.baseMr, value: baseMr)
        setIfNotEqual(entity: hero, path: \.baseAttackMin, value: baseAttackMin)
        setIfNotEqual(entity: hero, path: \.baseAttackMax, value: baseAttackMax)

        setIfNotEqual(entity: hero, path: \.baseStr, value: baseStr)
        setIfNotEqual(entity: hero, path: \.baseAgi, value: baseAgi)
        setIfNotEqual(entity: hero, path: \.baseInt, value: baseInt)
        setIfNotEqual(entity: hero, path: \.gainStr, value: strGain)
        setIfNotEqual(entity: hero, path: \.gainAgi, value: agiGain)
        setIfNotEqual(entity: hero, path: \.gainInt, value: intGain)

        setIfNotEqual(entity: hero, path: \.attackRange, value: attackRange)
        setIfNotEqual(entity: hero, path: \.projectileSpeed, value: projectileSpeed)
        setIfNotEqual(entity: hero, path: \.attackRate, value: attackRate)
        setIfNotEqual(entity: hero, path: \.moveSpeed, value: moveSpeed)
        setIfNotEqual(entity: hero, path: \.turnRate, value: turnRate ?? 0.6)
        return hero
    }
}
