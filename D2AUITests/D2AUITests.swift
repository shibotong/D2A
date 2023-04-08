//
//  D2AUITests.swift
//  D2AUITests
//
//  Created by Shibo Tong on 17/3/2023.
//

import XCTest

final class D2AUITests: XCTestCase {
    
    private let networkWaiting: UInt32 = 3
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeRight
        }
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Test register a player to app
    func testRegister() throws {
        let app = startApp()
        let textField = app.textFields["Search ID"]
        textField.tap()
        textField.typeText("153041957")
        app.buttons["Register Player"].tap()
        sleep(networkWaiting)
        XCTAssert(app.staticTexts["Mr.BOBOBO"].exists)
        takeScreenshot()
    }
    
    /// Test searching function of app
    func testSearch() {
        let app = startApp()
        if UIDevice.current.userInterfaceIdiom == .pad {
            app.buttons["Search"].tap()
        } else {
            app.tabBars["Tab Bar"].buttons["Search"].tap()
        }
        let textField = app.searchFields["Players, Heroes, Matches"]
        textField.tap()
        textField.typeText("Mr.BOBOBO")
        sleep(networkWaiting)
        // click enter on software keyboard
        app.keyboards.buttons["search"].tap()
        sleep(networkWaiting)
        XCTAssert(app.staticTexts["Mr.BOBOBO"].exists)
        takeScreenshot()
    }
    
    /// Test app user to favourite to app
    func testFavourite() {
        let app = startApp()
        if UIDevice.current.userInterfaceIdiom == .pad {
            app.buttons["Search"].tap()
        } else {
            app.tabBars["Tab Bar"].buttons["Search"].tap()
        }
        let textField = app.searchFields["Players, Heroes, Matches"]
        textField.tap()
        textField.typeText("Mr.BOBOBO")
        sleep(networkWaiting)
        // click enter on software keyboard
        app.keyboards.buttons["search"].tap()
        sleep(networkWaiting)
        app.buttons["153041957-153041957-153041957"].tap()
        sleep(networkWaiting)
        app.buttons["favourite"].tap()
        if UIDevice.current.userInterfaceIdiom == .pad {
            app.buttons["Home"].tap()
        } else {
            app.tabBars["Tab Bar"].buttons["Home"].tap()
        }
        XCTAssert(app.staticTexts["Mr.BOBOBO"].exists)
        takeScreenshot()
    }
    
    private func startApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["uitest"]
        app.launch()
        sleep(5)
        return app
    }

    private func takeScreenshot() {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
