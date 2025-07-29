//
//  D2AServiceCategory.swift
//  D2A
//
//  Created by Shibo Tong on 29/4/2025.
//

import OSLog

enum D2AServiceCategory: String {
    case constants = "🔍"
    case opendotaConstant = "📕"
    case coredata = "💾"
    case stratz = "🏉"
    case video = "🎥"
    case opendota = "🎮"
    case image = "📸"
}

enum LoggingLevel: Int {
    case info, debug, warn, error, fatal

    var icon: String {
        switch self {
        case .info:
            "ℹ️"
        case .debug:
            "📝"
        case .warn:
            "⚠️"
        case .error:
            "❌"
        case .fatal:
            "💥"
        }
    }
    
    var logLevel: OSLogType {
        switch self {
        case .info:
            return .info
        case .debug:
            return .debug
        case .warn:
            return .default
        case .error:
            return .error
        case .fatal:
            return .fault
        }
    }
}
