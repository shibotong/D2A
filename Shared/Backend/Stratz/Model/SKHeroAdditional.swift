//
//  SKHeroAdditional.swift
//  D2A
//
//  Created by Shibo Tong on 3/4/2026.
//

struct SKHeroAdditional {
    let heroID: Int
    let name: String
    let complexity: Int
    let roles: [Role]
    
    struct Role {
        let level: Int
        let roleId: String
    }
}
