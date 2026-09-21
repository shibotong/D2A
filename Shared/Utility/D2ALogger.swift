//
//  D2ALogger.swift
//  D2A
//
//  Created by Shibo Tong on 27/1/2026.
//

import Logging
import Foundation

enum LoggingCategory: String, CaseIterable {
    case image
    case setting
    case store
    case sync
    case ui
}

class D2ALogger {
    
    static let shared = D2ALogger()
    
    private static let logSettingsKey = "d2a.settings.log"
    
    var loggingLevels: [String: String] {
        var logSettings: [String: String] = [:]
        for logger in loggers {
            logSettings[logger.label] = logger.logLevel.rawValue
        }
        return logSettings
    }
    
    private var loggers: [Logger]
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        let logLevels = userDefaults.object(forKey: Self.logSettingsKey) as? [String: String] ?? [:]
        
        loggers = LoggingCategory.allCases.map { Logger(label: $0.rawValue, factory: { label in
            guard let logLevel = logLevels[label] else {
                return D2ALogHandler(label, logLevel: .warning)
            }
            let level = Logger.Level(rawValue: logLevel) ?? .warning
            return D2ALogHandler(label, logLevel: level)
        })}
        saveLogSettings()
    }
    
    func updateLogLevel(category: LoggingCategory, level: Logger.Level) {
        guard let index = loggers.firstIndex(where: { $0.label == category.rawValue }) else {
            critical("Logger \(category.rawValue) doesn't exist", category: .setting)
            return
        }
        loggers[index].logLevel = level
        notice("Update logger \(category) to level \(level)", category: .setting)
        saveLogSettings()
    }
    
    func trace(_ message: Logger.Message, category: LoggingCategory, file: String = #file, line: UInt = #line) {
        log(level: .trace, message: message, category: category, file: file, line: line)
    }
    
    func debug(_ message: Logger.Message, category: LoggingCategory, file: String = #file, line: UInt = #line) {
        log(level: .debug, message: message, category: category, file: file, line: line)
    }
    
    func info(_ message: Logger.Message, category: LoggingCategory, file: String = #file, line: UInt = #line) {
        log(level: .info, message: message, category: category, file: file, line: line)
    }
    
    func notice(_ message: Logger.Message, category: LoggingCategory, file: String = #file, line: UInt = #line) {
        log(level: .notice, message: message, category: category, file: file, line: line)
    }
    
    func warning(_ message: Logger.Message, category: LoggingCategory, file: String = #file, line: UInt = #line) {
        log(level: .warning, message: message, category: category, file: file, line: line)
    }
    
    func error(_ message: Logger.Message, category: LoggingCategory, file: String = #file, line: UInt = #line) {
        log(level: .error, message: message, category: category, file: file, line: line)
    }
    
    func critical(_ message: Logger.Message, category: LoggingCategory, file: String = #file, line: UInt = #line) {
        log(level: .critical, message: message, category: category, file: file, line: line)
        assertionFailure(message.description)
    }
    
    private func log(level: Logger.Level, message: Logger.Message, category: LoggingCategory, file: String, line: UInt) {
        let logger = logger(of: category)
        logger.log(level: level, message, metadata: nil, source: nil, file: file, line: line)
    }
    
    private func saveLogSettings() {
        userDefaults.set(loggingLevels, forKey: Self.logSettingsKey)
        info("Save log levels \(loggingLevels)", category: .setting)
    }
    
    private func logger(of category: LoggingCategory) -> Logger {
        guard let logger = loggers.first(where: { $0.label == category.rawValue }) else {
            assertionFailure("Cannot find logger \(category)")
            return Logger(label: category.rawValue)
        }
        return logger
    }
}

struct D2ALogHandler: LogHandler {
    subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get {
            return nil
        }
        set {
            return
        }
    }
    
    var metadata: Logging.Logger.Metadata = [:]
    
    var logLevel: Logging.Logger.Level
    
    private let label: String
    
    init(_ label: String, logLevel: Logger.Level) {
        self.logLevel = logLevel
        self.label = label
    }
    
    func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
        #if DEBUG
        print("\(level.icon) [\(label)] \(message) [\(file), line \(line)]")
        #endif
    }
}

extension Logger.Level {
    nonisolated var icon: String {
        switch self {
        case .trace:
            "🫆"
        case .debug:
            "🐞"
        case .info:
            "ℹ️"
        case .notice:
            "👀"
        case .warning:
            "⚠️"
        case .error:
            "❌"
        case .critical:
            "💥"
        }
    }
}
