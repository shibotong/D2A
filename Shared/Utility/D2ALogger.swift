//
//  D2ALogger.swift
//  D2A
//
//  Created by Shibo Tong on 27/1/2026.
//

import Logging
import Foundation

enum LoggingCategory: String, CaseIterable {
    case syncing
    case store
}

class D2ALogger {
    
    static let shared = D2ALogger()
    
    static var syncing = createLogger(label: "syncing")
    static var ui = createLogger(label: "UI")
    static var imageCache = createLogger(label: "imageCache")
    static var storeManager = createLogger(label: "storeManager")
    
    private var loggers: [Logger]
    private let userDefaults: UserDefaults
    
    private static let logSettingsKey = "d2a.log.settings"
    
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
        let logLevels = userDefaults.object(forKey: "logSettingsKey") as? [String: String] ?? [:]
        
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
            assertionFailure("Logger \(category.rawValue) doesn't exit")
            return
        }
        loggers[index].logLevel = level
        saveLogSettings()
    }
    

    
    static func createLogger(label: String, logLevel: Logger.Level = .debug) -> Logger {
        var logger = Logger(label: label)
        logger.logLevel = logLevel
        return logger
    }
    
    func trace(_ message: Logger.Message, category: LoggingCategory, file: String = #file, line: UInt = #line) {
        log(level: .trace, message: message, category: category, file: file, line: line)
    }
    
    func error(_ message: Logger.Message, category: LoggingCategory, file: String = #file, line: UInt = #line) {
        log(level: .error, message: message, category: category, file: file, line: line)
    }
    
    private func log(level: Logger.Level, message: Logger.Message, category: LoggingCategory, file: String, line: UInt) {
        let logger = logger(of: category)
        logger.log(level: level, message, metadata: nil, source: nil, file: file, line: line)
    }
    
    private func saveLogSettings() {
        var logSettings: [String: String] = [:]
        for logger in loggers {
            logSettings[logger.label] = logger.logLevel.rawValue
        }
        userDefaults.set(logSettings, forKey: Self.logSettingsKey)
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
        print("\(level.icon)\(label)\(level.icon) \(message) [\(file), line \(line)]")
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
