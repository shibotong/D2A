//
//  ODHero.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

struct ODHero: Decodable {
    let id: Int
    let name: String
    let primaryAttr: String
    let attackType: String
    let roles: [String]
    let img: String
    let icon: String
    let baseHealth: Int
    let baseHealthRegen: Double?
    let baseMana: Int
    let baseManaRegen: Double
    let baseArmor: Int
    let baseMr: Int
    let baseAttackMin: Int
    let baseAttackMax: Int
    let baseStr: Int
    let baseAgi: Int
    let baseInt: Int
    let strGain: Double
    let agiGain: Double
    let intGain: Double
    let attackRange: Int
    let projectileSpeed: Int
    let attackRate: Double
    let baseAttackTime: Int
    let attackPoint: Double
    let moveSpeed: Int
    let turnRate: Double?
    let cmEnabled: Bool
    let legs: Int
    let dayVision: Int
    let nightVision: Int
    let localizedName: String
}
