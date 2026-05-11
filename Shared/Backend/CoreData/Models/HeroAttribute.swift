//
//  HeroAttribute.swift
//  D2A
//
//  Created by Shibo Tong on 2/4/2026.
//

enum HeroAttribute: String, CaseIterable {
    case whole, str, agi, int, all
    
    var fullName: String {
        switch self {
        case .str:
            return "STRENGTH"
        case .agi:
            return "AGILITY"
        case .int:
            return "INTELLIGENCE"
        case .all:
            return "UNIVERSAL"
        default:
            return ""
        }
    }
}
