//
//  Logger.swift
//  D2A
//
//  Created by Shibo Tong on 1/8/2026.
//

import Logging

let logger = Logger(label: "Unit Test") { label in
    return UnitTestLogHandler()
}

class UnitTestLogHandler: LogHandler {
    var logLevel: Logging.Logger.Level = .error
    
    subscript(metadataKey key: String) -> Logging.Logger.Metadata.Value? {
        get {
            return metadata[key]
        }
        set(newValue) {
            metadata[key] = newValue
        }
    }
    
    var metadata: Logging.Logger.Metadata = [:]
    
    func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
        guard level == .error else {
            return
        }
        print("❌ \(message) [\(file), line \(line)]")
    }
}
