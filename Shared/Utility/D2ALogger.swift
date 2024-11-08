//
//  D2ALogger.swift
//  D2A
//
//  Created by Shibo Tong on 6/11/2024.
//

import Foundation

#if DEBUG

protocol Logging {
    func log(_ message: String, level: LoggerLevel, filePath: String, line: UInt)
}

enum LoggerLevel: Int {
    case debug, info, warning, error
    
    var icon: String {
        switch self {
        case .debug:
            return "📝"
        case .info:
            return "📄"
        case .warning:
            return "⚠️"
        case .error:
            return "🚨"
        }
    }
}

class D2ALogger: Logging {
    
    static let shared = D2ALogger(.error)
    
    var loggingLevel: LoggerLevel
    
    init(_ loggingLevel: LoggerLevel) {
        self.loggingLevel = loggingLevel
    }
    
    func log(_ message: String, level: LoggerLevel, filePath: String = #file, line: UInt = #line) {
        guard level.rawValue >= loggingLevel.rawValue else { return }
        
        let fileName = filePath.split(separator: "/").last!
        
        print("\(level.icon)[\(fileName)] \(message)")
    }
}
#endif
