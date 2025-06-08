//
//  ODAbility+Attribute.swift
//  D2A
//
//  Created by Shibo Tong on 2/5/2025.
//

extension ODAbility {
  struct Attribute: Codable, Hashable {

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
