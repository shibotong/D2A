//
//  HeroAttribute.swift
//  D2A
//
//  Created by Shibo Tong on 26/6/2025.
//

enum HeroAttribute: String, CaseIterable {
    case str
    case agi
    case int
    case uni = "all"
    
    var fullName: String {
        switch self {
        case .str:
            return "STRENGTH"
        case .agi:
            return "AGILITY"
        case .int:
            return "INTELLIGENCE"
        case .uni:
            return "UNIVERSAL"
        }
    }
    
    var displayName: String {
        switch self {
        case .str:
            return "Strength"
        case .agi:
            return "Agility"
        case .int:
            return "Intelligence"
        case .uni:
            return "Universal"
        }
    }
    
    var image: String {
        switch self {
        case .str:
            return "attribute_str"
        case .agi:
            return "attribute_agi"
        case .int:
            return "attribute_int"
        case .uni:
            return "attribute_uni"
        }
    }
}
