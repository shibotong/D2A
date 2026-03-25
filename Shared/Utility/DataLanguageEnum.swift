//
//  DataLanguageEnum.swift
//  D2A
//
//  Created by Shibo Tong on 25/3/2026.
//

import StratzAPI

enum DataLanguageEnum: String {
    case english
    case schinese
    
    var language: LanguageEnum {
        switch self {
        case .english:
            return .english
        case .schinese:
            return .sChinese
        }
    }
}
