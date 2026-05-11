//
//  SKAbility.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

struct SKAbility {
    let id: Int
    let name: String
    let displayName: String?
    let lore: String?
    let description: [String]
    let attributes: [String]?
    let aghanimDescription: String?
    let shardDescription: String?
    
    init(id: Int, name: String, displayName: String?, lore: String? = nil, description: [String] = [], attributes: [String]? = nil, aghanimDescription: String? = nil, shardDescription: String? = nil) {
        self.id = id
        self.name = name
        self.displayName = displayName
        self.lore = lore
        self.description = description
        self.attributes = attributes
        self.aghanimDescription = aghanimDescription
        self.shardDescription = shardDescription
    }
}
