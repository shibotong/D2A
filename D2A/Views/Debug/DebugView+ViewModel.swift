//
//  DebugView+ViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 6/12/2025.
//

import Foundation
import Logging

extension DebugView {
    class ViewModel: ObservableObject {
        @Published var levelSlider = 0.0
        let categoryName: String
        
        private var category: LoggingCategory
        private let debugLogger: D2ALogger
        
        init(_ loggingCategory: LoggingCategory,
             logger: D2ALogger = .shared) {
            categoryName = loggingCategory.rawValue
            category = loggingCategory
            self.debugLogger = logger
            levelSlider = Double(Logger.Level.allCases.firstIndex(of: category.logger.logLevel) ?? 0)
            debugLogger.trace("Log level for \(loggingCategory.rawValue) is \(category.logger.logLevel)", category: .debug)
        }
        
        func updateLogger() {
            let level = Logger.Level.allCases[Int(levelSlider)]
            category.loggingLevel = level
            debugLogger.debug("Set log level \(level) to \(category)", category: .debug)
        }
    }
}
