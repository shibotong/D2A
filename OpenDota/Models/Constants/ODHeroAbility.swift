//
//  ODHeroAbility.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

nonisolated
public struct ODHeroAbility: Decodable, Sendable {
    public let abilities: [String]
    public let talents: [Talent]
    public let facets: [Facet]
    
    public struct Talent: Decodable, Sendable {
        public let name: String
        public let level: Int
    }
    
    public struct Facet: Decodable, Sendable {
        public let id: Int
        public let name: String
        public let icon: String
        public let color: String
        public let gradientId: Int
        public let title: String
        public let description: String
    }
    
    enum CodingKeys: CodingKey {
        case abilities
        case talents
        case facets
    }
    
    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.abilities = try container.decode([String].self, forKey: .abilities)
        } catch {
            let abilitiesValue = try container.decode([StringOrArray].self, forKey: .abilities)
            var abilitiesArray: [String] = []
            abilitiesValue.forEach { value in
                switch value {
                case .string(let ability):
                    abilitiesArray.append(ability)
                case .array(let abilities):
                    abilitiesArray.append(contentsOf: abilities)
                }
            }
            self.abilities = abilitiesArray
        }
        self.talents = try container.decode([ODHeroAbility.Talent].self, forKey: .talents)
        self.facets = try container.decode([ODHeroAbility.Facet].self, forKey: .facets)
    }
}
