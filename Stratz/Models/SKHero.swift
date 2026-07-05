//
//  SKHero.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

public struct SKHero {
    public let id: Int
    public let roles: [Role]
    public let displayName: String
    public let lore: String
    public let hype: String
    
    public init(id: Int, roles: [Role], displayName: String, lore: String, hype: String) {
        self.id = id
        self.roles = roles
        self.displayName = displayName
        self.lore = lore
        self.hype = hype
    }
    
    public struct Role {
        public let level: Int
        public let roleId: String
        
        public init(level: Int, roleId: String) {
            self.level = level
            self.roleId = roleId
        }
    }
}
