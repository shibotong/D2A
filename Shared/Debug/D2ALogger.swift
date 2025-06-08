//
//  D2ALogger.swift
//  D2A
//
//  Created by Shibo Tong on 29/4/2025.
//

import Combine
import Foundation

func logDebug(
  _ message: String, category: D2AServiceCategory, file: String = #file,
  function: String = #function, line: Int = #line
) {
  D2ALogger.shared.log(
    level: .debug, message: message, category: category, file: file, function: function, line: line)
}

func logWarn(
  _ message: String, category: D2AServiceCategory, file: String = #file,
  function: String = #function, line: Int = #line
) {
  D2ALogger.shared.log(
    level: .warn, message: message, category: category, file: file, function: function, line: line)
}

func logError(
  _ message: String, category: D2AServiceCategory, file: String = #file,
  function: String = #function, line: Int = #line
) {
  D2ALogger.shared.log(
    level: .error, message: message, category: category, file: file, function: function, line: line)
}

class D2ALogger: ObservableObject {

  static let shared = D2ALogger()

  @Published var logging: Double

  private var cancellable: AnyCancellable?
  var loggingLevel: LoggingLevel = .warn

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
      guard level.rawValue >= loggingLevel.rawValue else {
        return
      }

      let fileName = file.components(separatedBy: "/").last ?? file

      print("\(level.icon) [\(category.rawValue)] [\(fileName): \(line) \(function)]: \(message)")
    #endif
  }
}
