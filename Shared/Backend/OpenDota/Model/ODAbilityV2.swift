//
//  ODAbilityV2.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

struct ODAbilityV2: Decodable {
    var img: String?
    var dname: String?
    var desc: String?
    var attrib: [AbilityAttribute]?
    var behavior: StringOrArray?
    var dmgType: StringOrArray?
    var bkbpierce: StringOrArray?
    var lore: String?
    var mc: StringOrArray?  // mana cost can be String or [String]
    var dispellable: String?
    var cd: StringOrArray?  // CD can be String or [String]
    var targetTeam: StringOrArray?
    var targetType: StringOrArray?
}
