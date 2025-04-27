//
//  AttributeSelection.swift
//  D2A
//
//  Created by Shibo Tong on 27/4/2025.
//

enum AttributeSelection: String, CaseIterable {
    case whole, str, agi, int, uni
    
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
        default:
            return ""
        }
    }
}

enum HeroAttribute: String {
    case str, agi, int, all
    
    var selection: AttributeSelection {
        switch self {
        case .str:
            return .str
        case .agi:
            return .agi
        case .int:
            return .int
        case .all:
            return .uni
        }
    }
}
