//
//  ODAbilityV2.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

import Foundation

nonisolated
public struct ODAbility: Decodable, Sendable {
    public let img: String?
    public let dname: String?
    public let desc: String?
    public let attrib: [Attribute]?
    public let behavior: [String]?
    public let dmgType: [String]?
    public let bkbpierce: [String]?
    public let lore: String?
    public let mc: [String]?  // mana cost can be String or [String]
    public let dispellable: String?
    public let cd: [String]?  // CD can be String or [String]
    public let targetTeam: [String]?
    public let targetType: [String]?
    
    enum CodingKeys: CodingKey {
        case img
        case dname
        case desc
        case attrib
        case behavior
        case dmgType
        case bkbpierce
        case lore
        case mc
        case cd
        case dispellable
        case targetTeam
        case targetType
    }
    
    public init(from decoder: any Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
        self.img = try container.decodeIfPresent(String.self, forKey: .img)
        self.dname = try container.decodeIfPresent(String.self, forKey: .dname)
        self.desc = try container.decodeIfPresent(String.self, forKey: .desc)
        self.attrib = try container.decodeIfPresent([Attribute].self, forKey: .attrib)
        self.behavior = try container.decodeIfPresent(StringOrArray.self, forKey: .behavior)?.arrayValue
        self.dmgType = try container.decodeIfPresent(StringOrArray.self, forKey: .dmgType)?.arrayValue
        self.bkbpierce = try container.decodeIfPresent(StringOrArray.self, forKey: .bkbpierce)?.arrayValue
        self.lore = try container.decodeIfPresent(String.self, forKey: .lore)
        self.mc = try container.decodeIfPresent(StringOrArray.self, forKey: .mc)?.arrayValue
        self.dispellable = try container.decodeIfPresent(String.self, forKey: .dispellable)
        self.cd = try container.decodeIfPresent(StringOrArray.self, forKey: .cd)?.arrayValue
        self.targetTeam = try container.decodeIfPresent(StringOrArray.self, forKey: .targetTeam)?.arrayValue
        self.targetType = try container.decodeIfPresent(StringOrArray.self, forKey: .targetType)?.arrayValue
    }
}


extension ODAbility {
    public struct Attribute: Decodable {
        public let key: String
        public let header: String
        public let value: [String]
        public let generated: Bool
        
        enum CodingKeys: CodingKey {
            case key
            case header
            case value
            case generated
        }
        
        public init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
            self.key = try container.decode(String.self, forKey: .key)
            self.header = try container.decode(String.self, forKey: .header)
            self.value = try container.decode(StringOrArray.self, forKey: .value).arrayValue
            self.generated = try container.decodeIfPresent(Bool.self, forKey: .generated) ?? false
        }
    }
}
