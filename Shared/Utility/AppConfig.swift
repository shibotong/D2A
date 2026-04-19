//
//  AppConfig.swift
//  D2A
//
//  Created by Shibo Tong on 24/3/2026.
//

import StratzAPI
import Foundation

protocol AppConfigProtocol {
    var languageCode: DataLanguageEnum { get }
    var processors: Int { get }
}

class AppConfig: AppConfigProtocol {
    
    static let shared = AppConfig()
    
    let languageCode: DataLanguageEnum = {
        let currentLanguage: String = Locale.current.languageCode ?? "en"
        switch currentLanguage {
        case "en":
            return .english
        case "zh":
            return .schinese
        default:
            return .english
        }
    }()
    
    let processors: Int = ProcessInfo.processInfo.processorCount
}
