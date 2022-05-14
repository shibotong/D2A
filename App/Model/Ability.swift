//
//  Ability.swift
//  App
//
//  Created by Shibo Tong on 12/9/21.
//

import Foundation

struct Ability: Codable {
    var img: String?
    var dname: String?
    var desc: String?
    var attributes: [AbilityAttribute]?
    var behavior: StringOrArray?
    var damageType: StringOrArray?
    var bkbPierce: StringOrArray?
    var lore: String?
    var manaCost: StringOrArray?  // mana cost can be String or [String]
    var dispellable: StringOrArray?
    var coolDown: StringOrArray?  // CD can be String or [String]
    var targetTeam: StringOrArray?
    var targetType: StringOrArray?
    
    enum CodingKeys: String, CodingKey {
        case img = "img"
        case dname
        case desc
        case attributes = "attrib"
        case behavior
        case damageType = "dmg_type"
        case bkbPierce = "bkbpierce"
        case lore
        case manaCost = "mc"
        case dispellable
        case coolDown = "cd"
        case targetTeam = "target_team"
        case targetType = "target_type"
    }
}

struct AbilityAttribute: Codable {
    var key: String?
    var header: String?
    var value: StringOrArray?
    var generated: Bool?
    
    enum CodingKeys: String, CodingKey {
        case key
        case header
        case value
        case generated
    }
}

enum StringOrArray: Codable {
    case string(String)
    case array([String])
    
    init(from decoder: Decoder) throws {
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        if let array = try? decoder.singleValueContainer().decode([String].self) {
            self = .array(array)
            return
        }
        throw Error.couldNotFindStringOrArray
    }
    
    enum Error: Swift.Error {
        case couldNotFindStringOrArray
    }
}
