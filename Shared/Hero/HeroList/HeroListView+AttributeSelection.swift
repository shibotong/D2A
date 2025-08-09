//
//  HeroListView+AttributeSelection.swift
//  D2A
//
//  Created by Shibo Tong on 1/7/2025.
//

import Foundation

extension HeroListView {
    enum AttributeSelection: String, CaseIterable {
        case all = "All"
        case str = "Strength"
        case agi = "Agility"
        case int = "Intelligence"
        case uni = "Universal"
        
        var attributes: [HeroAttribute] {
            switch self {
            case .all: return [.str, .agi, .int, .uni]
            case .str: return [.str]
            case .agi: return [.agi]
            case .int: return [.int]
            case .uni: return [.uni]
            }
        }
        
        var image: String {
            switch self {
            case .all: return ""
            case .str: return "attribute_str"
            case .agi: return "attribute_agi"
            case .int: return "attribute_int"
            case .uni: return "attribute_uni"
            }
        }
    }
}
