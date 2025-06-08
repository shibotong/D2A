//
//  XCTestCase+Extension.swift
//  D2AUITests
//
//  Created by Shibo Tong on 5/2/2024.
//

import XCTest

extension XCTestCase {

  var networkWaiting: UInt32 {
    return 3
  }

  var userID: String {
    return "153041957"
  }
  var userName: String {
    return "Mr.BOBOBO"
  }

  var hero: String {
    return "Alchemist"
  }
  var ability: String {
    return "alchemist_acid_spray"
  }

  /// Start App
  func startApp() -> XCUIApplication {
    let app = XCUIApplication()
    app.launchArguments = ["uitest"]
    app.launch()
    sleep(5)
    return app
  }

  // Capture Screenshot
  func takeScreenshot(_ name: String? = nil) {
    let screenshot = XCUIScreen.main.screenshot()
    let attachment = XCTAttachment(screenshot: screenshot)
    attachment.name = name
    attachment.lifetime = .keepAlways
    add(attachment)
  }
}
