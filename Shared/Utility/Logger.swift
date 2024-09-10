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

fileprivate let LOGGER_SAVE_KEY = "dotaArmory.logging"

class Logger {
    
    static let shared = Logger()
    
    var loggingLevel: LoggingLevel {
        didSet {
            log(level: .verbose, message: "Set logging level \(loggingLevel.name)")
            UserDefaults.standard.set(loggingLevel.rawValue, forKey: LOGGER_SAVE_KEY)
        }
    }
    
    init() {
        let level = UserDefaults.standard.integer(forKey: LOGGER_SAVE_KEY)
        loggingLevel = LoggingLevel(rawValue: level) ?? .error
    }
    
    func log(level: LoggingLevel, message: String, file: String = #file, line: Int = #line) {
        guard level.rawValue >= loggingLevel.rawValue else {
            return
        }
        print("\(level.icon) [\(file) line: \(line)] \(message)")
    }
}
