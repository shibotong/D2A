//
//  D2ALogger.swift
//  D2A
//
//  Created by Shibo Tong on 29/4/2025.
//

import Foundation
import Combine

func logDebug(_ message: String, category: D2AServiceCategory) {
     D2ALogger.shared.log(level: .debug, message: message, category: category)
 }

 func logWarn(_ message: String, category: D2AServiceCategory) {
     D2ALogger.shared.log(level: .warn, message: message, category: category)
 }

 func logError(_ message: String, category: D2AServiceCategory) {
     D2ALogger.shared.log(level: .error, message: message, category: category)
 }

 class D2ALogger: ObservableObject {

     static let shared = D2ALogger()

     @Published var logging: Double = 1
     
     private var cancellable: AnyCancellable?
    var loggingLevel: LoggingLevel = .warn
     
     init() {
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
     
     func log(level: LoggingLevel, message: String, category: D2AServiceCategory) {
         #if DEBUG
         guard level.rawValue >= loggingLevel.rawValue else {
             return
         }
         print("\(level.icon) [\(category.rawValue)] \(message)")
         #endif
     }
 }
