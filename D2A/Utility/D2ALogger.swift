//
//  D2ALogger.swift
//  D2A
//
//  Created by Shibo Tong on 27/1/2026.
//

import Logging

class D2ALogger {
    static var syncing = createLogger(label: "syncing")
    
    static func createLogger(label: String, logLevel: Logger.Level = .debug) -> Logger {
        var logger = Logger(label: label)
        logger.logLevel = logLevel
        return logger
    }
}
