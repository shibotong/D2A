//
//  HeroV2.swift
//  D2A
//
//  Created by Shibo Tong on 6/9/2024.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
class HeroV2 {
    @Attribute(.unique)
    var id: Int
    
    var name: String
    var primaryAttribute: String
    var attackType: String
    
    var baseHealth: Int
    var baseHealthRegen: Int
    
    var baseMana: Int
    var baseManaRegen: Int
    
    var baseArmor: Int
    var baseMr: Int
    
    var baseAttackMin: Int
    var baseAttackMax: Int
    
    var baseStr: Int
    var baseAgi: Int
    var baseInt: Int
    
    var gainStr: Double
    var gainAgi: Double
    var gainInt: Double
    
    var attackRange: Int
    var projectileSpeed: Int
    
    var attackRate: Double
    var baseAttackTime: Int
    
    var attackPoint: Double
    var moveSpeed: Int
    
    var turnRate: Double
    var cmEnabled: Bool
    var legs: Int
    var dayVision: Int
    var nightVision: Int
    
    @Relationship(deleteRule: .cascade, inverse: \HeroV2Localisation.hero)
    var localisations: [HeroV2Localisation] = []
    
    @Relationship(deleteRule: .cascade, inverse: \RoleV2.hero)
    var roles: [RoleV2] = []
    
    @Relationship(deleteRule: .cascade, inverse: \AbilityV2.hero)
    var abilities: [AbilityV2] = []
    
    init(id: Int, name: String, primaryAttribute: String, attackType: String, baseHealth: Int, baseHealthRegen: Int, baseMana: Int, baseManaRegen: Int, baseArmor: Int, baseMr: Int, baseAttackMin: Int, baseAttackMax: Int, baseStr: Int, baseAgi: Int, baseInt: Int, gainStr: Double, gainAgi: Double, gainInt: Double, attackRange: Int, projectileSpeed: Int, attackRate: Double, baseAttackTime: Int, attackPoint: Double, moveSpeed: Int, turnRate: Double, cmEnabled: Bool, legs: Int, dayVision: Int, nightVision: Int, localisations: [HeroV2Localisation], roles: [RoleV2], abilities: [AbilityV2]) {
        self.id = id
        self.name = name
        self.primaryAttribute = primaryAttribute
        self.attackType = attackType
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
        self.gainStr = gainStr
        self.gainAgi = gainAgi
        self.gainInt = gainInt
        self.attackRange = attackRange
        self.projectileSpeed = projectileSpeed
        self.attackRate = attackRate
        self.baseAttackTime = baseAttackTime
        self.attackPoint = attackPoint
        self.moveSpeed = moveSpeed
        self.turnRate = turnRate
        self.cmEnabled = cmEnabled
        self.legs = legs
        self.dayVision = dayVision
        self.nightVision = nightVision
        self.localisations = localisations
        self.roles = roles
        self.abilities = abilities
    }
}
