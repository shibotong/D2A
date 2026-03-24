//
//  SKHero.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

struct SKHero {
    let id: Int
    let roles: [Role]
    let language: Language
    
    
    struct Role {
        let level: Int
        let roleId: Int
    }
    
    struct Language {
        let displayName: String
        let lore: String
        let hype: String
    }
}
