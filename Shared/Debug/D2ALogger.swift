//
//  D2ALogger.swift
//  D2A
//
//  Created by Shibo Tong on 29/4/2025.
//

import Combine
import Foundation
import OSLog

func logInfo(
    _ message: String, category: D2AServiceCategory, file: String = #file,
    function: String = #function, line: Int = #line
) {
    D2ALogger.shared.log(
        level: .info, message: message, category: category, file: file, function: function,
        line: line)
}

func logDebug(
    _ message: String, category: D2AServiceCategory, file: String = #file,
    function: String = #function, line: Int = #line
) {
    D2ALogger.shared.log(
        level: .debug, message: message, category: category, file: file, function: function,
        line: line)
}

func logWarn(
    _ message: String, category: D2AServiceCategory, file: String = #file,
    function: String = #function, line: Int = #line
) {
    D2ALogger.shared.log(
        level: .warn, message: message, category: category, file: file, function: function,
        line: line)
}

func logError(
    _ message: String, category: D2AServiceCategory, file: String = #file,
    function: String = #function, line: Int = #line
) {
    D2ALogger.shared.log(
        level: .error, message: message, category: category, file: file, function: function,
        line: line)
}

func logFatal(
    _ message: String, category: D2AServiceCategory, file: String = #file,
    function: String = #function, line: Int = #line
) {
    D2ALogger.shared.log(
        level: .fatal, message: message, category: category, file: file, function: function,
        line: line)
}

class D2ALogger: ObservableObject {

    static let shared = D2ALogger()

    @Published var logging: Double

    private var cancellable: AnyCancellable?
    var loggingLevel: LoggingLevel = .warn
    private let logger = Logger(subsystem: "com.shibotongdev.D2A", category: "persistence")

    init() {
        logging = Double(loggingLevel.rawValue)
        setupBinding()
    }

    private func setupBinding() {
        cancellable = $logging.sink { [weak self] logLevel in
            guard let level = LoggingLevel(rawValue: Int(logLevel)) else {
                return
            }
            self?.loggingLevel = level
        }
    }

    func log(
        level: LoggingLevel, message: String, category: D2AServiceCategory, file: String,
        function: String, line: Int
    ) {
        #if DEBUG
        let fileName = file.components(separatedBy: "/").last ?? file
        let logMessage = "\(level.icon) [\(category.rawValue)] [\(fileName):\(line)]: \(message)"
        logger.log(level: level.logLevel, "\(logMessage)")
        guard level.rawValue >= loggingLevel.rawValue else {
            return
        }
        print(logMessage)
        if level == .fatal {
            assertionFailure(logMessage)
        }
        #endif
    }
}
