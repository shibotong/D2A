//
//  Logger.swift
//  D2A
//
//  Created by Shibo Tong on 10/9/2024.
//

import Foundation

enum LoggingLevel: Int, CaseIterable {
    case verbose, warning, error
    
    var icon: String {
        switch self {
        case .verbose:
            "📝"
        case .warning:
            "⚠️"
        case .error:
            "🚨"
        }
    }
    
    var name: String {
        switch self {
        case .verbose:
            "VERB"
        case .warning:
            "WARN"
        case .error:
            "ERROR"
        }
    }
}

class Logger {
    
    static let shared = Logger()
    
    var loggingLevel: LoggingLevel = .error
    
    func log(level: LoggingLevel, message: String) {
        guard level.rawValue >= loggingLevel.rawValue else {
            return
        }
        print("\(level.icon) \(message)")
    }
}
