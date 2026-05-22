//
//  SKAbility.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

public struct SKAbility {
    public let id: Int
    public let name: String
    public let displayName: String?
    public let lore: String?
    public let description: [String]
    public let attributes: [String]?
    public let aghanimDescription: String?
    public let shardDescription: String?
    
    public init(id: Int, name: String, displayName: String?, lore: String? = nil, description: [String] = [], attributes: [String]? = nil, aghanimDescription: String? = nil, shardDescription: String? = nil) {
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
