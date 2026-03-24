//
//  AppConfig.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

import StratzAPI
import Foundation

class AppConfig {
    static let languageCode: StratzAPI.LanguageEnum = {
        let currentLanguage: String = Locale.current.languageCode ?? "en"
        switch currentLanguage {
        case "en":
            return .english
        case "zh":
            return .sChinese
        default:
            return .english
        }
    }()
}
