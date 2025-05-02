//
//  ODAbility+Attribute.swift
//  D2A
//
//  Created by Shibo Tong on 2/5/2025.
//

extension ODAbility {
    struct Attribute: Codable, Hashable, D2ABatchInsertable {
        var dictionaries: [String: Any] {
            var result: [String: Any] = [:]
            if let key = key {
                result["key"] = key
            }
            if let header = header {
                result["header"] = header
            }
            if let value = value {
                result["value"] = value.transformString()
            }
            if let generated = generated {
                result["generated"] = generated
            }
            return result
        }
        
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
        
        static func == (lhs: Attribute, rhs: Attribute) -> Bool {
            return lhs.key == rhs.key
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(key)
        }
    }
}
