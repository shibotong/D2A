//
//  Logger.swift
//  D2A
//
//  Created by Shibo Tong on 2/12/2025.
//

import Logging

let logger = Logger(label: "com.shibodev.dotaarmory")

extension Logger {
    static let image = Logger(label: "🏙️")
    static let coredata = Logger(label: "🔄")
}

class D2ALogger {
    static let shared = D2ALogger()
    
    func log(level: Logger.Level, message: @autoclosure () -> Logger.Message, logger: Logger) {
        logger.log(level: level, message())
    }
    
    /// Appropriate for messages that contain information normally of use only when
    /// tracing the execution of a program.
    func trace(_ message: @autoclosure () -> Logger.Message, logger: Logger) {
        log(level: .trace, message: message(), logger: logger)
    }

    /// Appropriate for messages that contain information normally of use only when
    /// debugging a program.
    func debug(_ message: @autoclosure () -> Logger.Message, logger: Logger) {
        log(level: .debug, message: message(), logger: logger)
    }

    /// Appropriate for informational messages.
    func info(_ message: @autoclosure () -> Logger.Message, logger: Logger) {
        log(level: .info, message: message(), logger: logger)
    }

    /// Appropriate for conditions that are not error conditions, but that may require
    /// special handling.
    func notice(_ message: @autoclosure () -> Logger.Message, logger: Logger) {
        log(level: .notice, message: message(), logger: logger)
    }

    /// Appropriate for messages that are not error conditions, but more severe than
    /// `.notice`.
    func warning(_ message: @autoclosure () -> Logger.Message, logger: Logger) {
        log(level: .warning, message: message(), logger: logger)
    }

    /// Appropriate for error conditions.
    func error(_ message: @autoclosure () -> Logger.Message, logger: Logger) {
        log(level: .error, message: message(), logger: logger)
    }

    /// Appropriate for critical error conditions that usually require immediate
    /// attention.
    ///
    /// When a `critical` message is logged, the logging backend (`LogHandler`) is free to perform
    /// more heavy-weight operations to capture system state (such as capturing stack traces) to facilitate
    /// debugging.
    func critical(_ message: @autoclosure () -> Logger.Message, logger: Logger) {
        log(level: .critical, message: message(), logger: logger)
    }
}
