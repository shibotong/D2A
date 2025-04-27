//
//  D2ALogger.swift
//  D2A
//
//  Created by Shibo Tong on 27/4/2025.
//

import Foundation

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

func logDebug(_ message: String) {
    D2ALogger.shared.log(level: .debug, message: message)
}

func logWarn(_ message: String) {
    D2ALogger.shared.log(level: .warn, message: message)
}

func logError(_ message: String) {
    D2ALogger.shared.log(level: .error, message: message)
}

class D2ALogger: ObservableObject {
    
    static let shared = D2ALogger()
    
    @Published var loggingLevel: LoggingLevel = .warn
    
    func log(level: LoggingLevel, message: String) {
        guard level.rawValue >= loggingLevel.rawValue else {
            return
        }
        print("\(level.icon) \(message)")
    }
}
