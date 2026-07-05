//
//  DataLanguageEnum.swift
//  D2A
//
//  Created by Shibo Tong on 25/3/2026.
//

import Stratz

enum DataLanguageEnum: String, CaseIterable {
    case english
    case schinese
    
    var language: StratzLanguage {
        switch self {
        case .english:
            return .english
        case .schinese:
            return .schinese
        }
    }
}
