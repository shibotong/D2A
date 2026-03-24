//
//  ODHeroAbilities.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

struct ODHeroAbilities: Decodable {
    let abilities: [String]
    let talents: [Talent]
    let facets: [Facet]
    
    struct Talent: Decodable {
        let name: String
        let level: Int
    }
    
    struct Facet: Decodable {
        let id: Int
        let name: String
        let icon: String
        let color: String
        let gradientId: Int
        let title: String
        let description: String
    }
}
