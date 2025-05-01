//
//  StratzLanguage.swift
//  D2A
//
//  Created by Shibo Tong on 29/4/2025.
//

extension StratzAbility {
    struct Language {
        var displayName: String
        var description: [String]
        var attributes: [String]
        var lore: String?
        var aghanimDescription: String?
        var shardDescription: String?
        var notes: [String]
    }
    
    struct Attribute {
        var name: String
        var value: String
    }
}
