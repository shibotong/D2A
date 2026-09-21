//
//  LoggerView+ViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 21/9/2026.
//

import Foundation
import Logging

extension LoggerView {
    class ViewModel: ObservableObject {
        
        @Published var loggingLevels: [LoggingLevel]
        
        private let logger: D2ALogger
        
        init(logger: D2ALogger = .shared) {
            self.logger = logger
            let levels = logger.loggingLevels
            self.loggingLevels = levels.map { level in
                return LoggingLevel(level: Logger.Level(rawValue: level.value) ?? .warning,
                             category: LoggingCategory(rawValue: level.key) ?? .store,
                             logger: logger)
            }
        }
    }
}
