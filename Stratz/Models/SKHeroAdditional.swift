//
//  SKHeroAdditional.swift
//  D2A
//
//  Created by Shibo Tong on 3/4/2026.
//

public struct SKHeroAdditional {
    public let heroID: Int
    public let name: String
    public let complexity: Int
    public let roles: [Role]
    
    public init(heroID: Int, name: String, complexity: Int, roles: [Role]) {
        self.heroID = heroID
        self.name = name
        self.complexity = complexity
        self.roles = roles
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
