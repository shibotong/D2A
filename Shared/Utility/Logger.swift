//
//  Logger.swift
//  D2A
//
//  Created by Shibo Tong on 2/12/2025.
//

import Logging

enum LoggingCategory: String, CaseIterable {
    case app = "Application"
    case coredata = "CoreData"
    case debug = "Debug"
    case image = "Image"
    case network = "Network"
    
    var loggingLevel: Logger.Level {
        set {
            switch self {
            case .app:
                Logger.app.logLevel = newValue
            case .coredata:
                Logger.coredata.logLevel = newValue
            case .debug:
                Logger.debug.logLevel = newValue
            case .image:
                Logger.image.logLevel = newValue
            case .network:
                Logger.network.logLevel = newValue
            }
        }
        get {
            logger.logLevel
        }
    }
    
    var logger: Logger {
        switch self {
        case .app:
            return .app
        case .coredata:
            return .coredata
        case .image:
            return .image
        case .debug:
            return .debug
        case .network:
            return .network
        }
    }
}

extension Logger {
    static var app = createLogger(label: "📱")
    static var image = createLogger(label: "🏙️")
    static var coredata = createLogger(label: "📁")
    static var debug = createLogger(label: "✏️")
    static var network = createLogger(label: "🛜")
    
    static func createLogger(label: String) -> Logger {
        return Logger(label: label) { label in
            return D2ALogHandler(label: label)
        }
    }
}

class D2ALogger {
    static let shared = D2ALogger()
    
    private func log(level: Logger.Level,
                     message: @autoclosure () -> Logger.Message,
                     logger: Logger,
                     file: String = #fileID,
                     function: String = #function,
                     line: UInt = #line) {
        logger.log(level: level, message(), file: file, function: function, line: line)
    }
    
    /// Appropriate for messages that contain information normally of use only when
    /// tracing the execution of a program.
    func trace(_ message: @autoclosure () -> Logger.Message,
               category: Logger,
               file: String = #fileID,
               function: String = #function,
               line: UInt = #line) {
        log(level: .trace, message: message(), logger: category, file: file, function: function, line: line)
    }

    /// Appropriate for messages that contain information normally of use only when
    /// debugging a program.
    func debug(_ message: @autoclosure () -> Logger.Message,
               category: Logger,
               file: String = #fileID,
               function: String = #function,
               line: UInt = #line) {
        log(level: .debug, message: message(), logger: category, file: file, function: function, line: line)
    }

    /// Appropriate for informational messages.
    func info(_ message: @autoclosure () -> Logger.Message,
              category: Logger,
              file: String = #fileID,
              function: String = #function,
              line: UInt = #line) {
        log(level: .info, message: message(), logger: category, file: file, function: function, line: line)
    }

    /// Appropriate for conditions that are not error conditions, but that may require
    /// special handling.
    func notice(_ message: @autoclosure () -> Logger.Message,
                category: Logger,
                file: String = #fileID,
                function: String = #function,
                line: UInt = #line) {
        log(level: .notice, message: message(), logger: category, file: file, function: function, line: line)
    }

    /// Appropriate for messages that are not error conditions, but more severe than
    /// `.notice`.
    func warning(_ message: @autoclosure () -> Logger.Message,
                 category: Logger,
                 file: String = #fileID,
                 function: String = #function,
                 line: UInt = #line) {
        log(level: .warning, message: message(), logger: category, file: file, function: function, line: line)
    }

    /// Appropriate for error conditions.
    func error(_ message: @autoclosure () -> Logger.Message,
               category: Logger,
               file: String = #fileID,
               function: String = #function,
               line: UInt = #line) {
        log(level: .error, message: message(), logger: category, file: file, function: function, line: line)
    }

    /// Appropriate for critical error conditions that usually require immediate
    /// attention.
    ///
    /// When a `critical` message is logged, the logging backend (`LogHandler`) is free to perform
    /// more heavy-weight operations to capture system state (such as capturing stack traces) to facilitate
    /// debugging.
    func critical(_ message: @autoclosure () -> Logger.Message,
                  category: Logger,
                  file: String = #fileID,
                  function: String = #function,
                  line: UInt = #line) {
        log(level: .critical, message: message(), logger: category, file: file, function: function, line: line)
    }
}

struct D2ALogHandler: LogHandler {
    subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get {
            return self.metadata[key]
        }
        set(newValue) {
            self.metadata[key] = newValue
        }
    }
    
    var metadata: Logging.Logger.Metadata = [:]
    
    var logLevel: Logging.Logger.Level = .debug
    
    private let label: String
    
    init(label: String) {
        self.label = label
    }
    
    func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
        print("\(level.icon) [\(label) \(file):\(line)] \(message)")
        if level == .critical {
            assertionFailure()
        }
    }
}

extension Logger.Level {
    var icon: String {
        switch self {
        case .trace:
            return "📝"
        case .debug:
            return "💻"
        case .info:
            return "ℹ️"
        case .notice:
            return "👀"
        case .warning:
            return "⚠️"
        case .error:
            return "❌"
        case .critical:
            return "🤡"
        }
    }
}

