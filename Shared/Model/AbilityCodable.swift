//
//  Ability.swift
//  App
//
//  Created by Shibo Tong on 12/9/21.
//

import Foundation

struct AbilityCodable: Codable, Identifiable {
    var id = UUID()
    
    var img: String?
    var dname: String?
    var desc: String?
    var attributes: [AbilityCodableAttribute]?
    var behavior: StringOrArray?
    var damageType: StringOrArray?
    var bkbPierce: StringOrArray?
    var lore: String?
    var manaCost: StringOrArray?  // mana cost can be String or [String]
    var dispellable: StringOrArray?
    var coolDown: StringOrArray?  // CD can be String or [String]
    var targetTeam: StringOrArray?
    var targetType: StringOrArray?
    
    var name: String? {
        guard let imageURL = img else {
            return nil
        }
        let name = imageURL
            .replacingOccurrences(of: "/apps/dota2/images/dota_react/abilities/", with: "")
            .replacingOccurrences(of: "_md", with: "")
            .replacingOccurrences(of: ".png", with: "")
        return name
    }
    
    var imageURL: String? {
        guard let imageURL = img?
            .replacingOccurrences(of: "_md", with: "")
            .replacingOccurrences(of: "images/abilities", with: "images/dota_react/abilities") else {
            return nil
        }
        return "\(IMAGE_PREFIX)\(imageURL)"
    }
    
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

struct AbilityCodableAttribute: Codable, Hashable {
    
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
    
    static func == (lhs: AbilityCodableAttribute, rhs: AbilityCodableAttribute) -> Bool {
        return lhs.key == rhs.key
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(key)
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
    
    func transformString() -> String? {
        switch self {
        case .string(let string):
            return string
        case .array(let array):
            if array.contains("Point Target") {
                return "Point Target"
            }
            if array.contains("Unit Target") {
                return "Unit Target"
            }
            if array.contains("No Target") {
                return "No Target"
            }
            return array.joined(separator: " / ")
        }
    }
}

struct AbilityContainer: Identifiable {
    var id = UUID()
    var ability: AbilityCodable
    var heroID: Int
    var abilityName: String
}
