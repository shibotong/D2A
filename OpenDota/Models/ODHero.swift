//
//  ODHero.swift
//  D2A
//
//  Created by Shibo Tong on 20/5/2026.
//

nonisolated
public struct ODHero: Decodable, Sendable {
    public let id: Int
    public let name: String
    public let primaryAttr: String
    public let attackType: String
    public let roles: [String]
    public let img: String
    public let icon: String
    public let baseHealth: Int
    public let baseHealthRegen: Double
    public let baseMana: Int
    public let baseManaRegen: Double
    public let baseArmor: Int
    public let baseMr: Int
    public let baseAttackMin: Int
    public let baseAttackMax: Int
    public let baseStr: Int
    public let baseAgi: Int
    public let baseInt: Int
    public let strGain: Double
    public let agiGain: Double
    public let intGain: Double
    public let attackRange: Int
    public let projectileSpeed: Int
    public let attackRate: Double
    public let baseAttackTime: Int
    public let attackPoint: Double
    public let moveSpeed: Int
    public let turnRate: Double?
    public let cmEnabled: Bool
    public let legs: Int
    public let dayVision: Int
    public let nightVision: Int
    public let localizedName: String
 
    enum CodingKeys: CodingKey {
        case id
        case name
        case primaryAttr
        case attackType
        case roles
        case img
        case icon
        case baseHealth
        case baseHealthRegen
        case baseMana
        case baseManaRegen
        case baseArmor
        case baseMr
        case baseAttackMin
        case baseAttackMax
        case baseStr
        case baseAgi
        case baseInt
        case strGain
        case agiGain
        case intGain
        case attackRange
        case projectileSpeed
        case attackRate
        case baseAttackTime
        case attackPoint
        case moveSpeed
        case turnRate
        case cmEnabled
        case legs
        case dayVision
        case nightVision
        case localizedName
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.primaryAttr = try container.decode(String.self, forKey: .primaryAttr)
        self.attackType = try container.decode(String.self, forKey: .attackType)
        self.roles = try container.decode([String].self, forKey: .roles)
        self.img = try container.decode(String.self, forKey: .img)
        self.icon = try container.decode(String.self, forKey: .icon)
        self.baseHealth = try container.decode(Int.self, forKey: .baseHealth)
        self.baseHealthRegen = try container.decode(Double.self, forKey: .baseHealthRegen)
        self.baseMana = try container.decode(Int.self, forKey: .baseMana)
        self.baseManaRegen = try container.decode(Double.self, forKey: .baseManaRegen)
        self.baseArmor = try container.decode(Int.self, forKey: .baseArmor)
        self.baseMr = try container.decode(Int.self, forKey: .baseMr)
        self.baseAttackMin = try container.decode(Int.self, forKey: .baseAttackMin)
        self.baseAttackMax = try container.decode(Int.self, forKey: .baseAttackMax)
        self.baseStr = try container.decode(Int.self, forKey: .baseStr)
        self.baseAgi = try container.decode(Int.self, forKey: .baseAgi)
        self.baseInt = try container.decode(Int.self, forKey: .baseInt)
        self.strGain = try container.decode(Double.self, forKey: .strGain)
        self.agiGain = try container.decode(Double.self, forKey: .agiGain)
        self.intGain = try container.decode(Double.self, forKey: .intGain)
        self.attackRange = try container.decode(Int.self, forKey: .attackRange)
        self.projectileSpeed = try container.decode(Int.self, forKey: .projectileSpeed)
        self.attackRate = try container.decode(Double.self, forKey: .attackRate)
        self.baseAttackTime = try container.decode(Int.self, forKey: .baseAttackTime)
        self.attackPoint = try container.decode(Double.self, forKey: .attackPoint)
        self.moveSpeed = try container.decode(Int.self, forKey: .moveSpeed)
        self.turnRate = try container.decodeIfPresent(Double.self, forKey: .turnRate) ?? 0.6
        self.cmEnabled = try container.decode(Bool.self, forKey: .cmEnabled)
        self.legs = try container.decodeIfPresent(Int.self, forKey: .legs) ?? 0
        self.dayVision = try container.decode(Int.self, forKey: .dayVision)
        self.nightVision = try container.decode(Int.self, forKey: .nightVision)
        self.localizedName = try container.decode(String.self, forKey: .localizedName)
    }
}
