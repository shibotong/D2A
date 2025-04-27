//
//  D2ALogger.swift
//  D2A
//
//  Created by Shibo Tong on 27/4/2025.
//

import Foundation

enum D2AServiceCategory: String {
    case opendotaConstant
}

enum LoggingLevel: Int {
    case debug, warn, error
    
    var icon: String {
        switch self {
        case .debug:
            "📝"
        case .warn:
            "⚠️"
        case .error:
            "❌"
        }
    }
}

func logDebug(_ message: String, category: D2AServiceCategory) {
    D2ALogger.shared.log(level: .debug, message: message, category: category)
}

func logWarn(_ message: String, category: D2AServiceCategory) {
    D2ALogger.shared.log(level: .warn, message: message, category: category)
}

func logError(_ message: String, category: D2AServiceCategory) {
    D2ALogger.shared.log(level: .error, message: message, category: category)
}

class D2ALogger: ObservableObject {
    
    static let shared = D2ALogger()
    
    @Published var loggingLevel: LoggingLevel = .warn
    
    func log(level: LoggingLevel, message: String, category: D2AServiceCategory) {
        guard level.rawValue >= loggingLevel.rawValue else {
            return
        }
        print("\(level.icon) [\(category.rawValue)] \(message)")
    }
}
