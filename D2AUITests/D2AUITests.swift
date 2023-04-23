//
//  D2AUITests.swift
//  D2AUITests
//
//  Created by Shibo Tong on 17/3/2023.
//

import XCTest

extension XCTestCase {
    
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

final class D2AUITests: XCTestCase {
    
    private let networkWaiting: UInt32 = 3
    
    private var userid: String!
    private var username: String!

    override func setUpWithError() throws {
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeRight
        }
        
        // In UI tests it is usually best to stop immediately when a failure occurs.

        let testCase = TestCaseString()
        userid = testCase.userid
        username = testCase.username
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    /// Test register a player to app
    func testRegister() {
        let app = startApp()
        let textField = app.textFields["Search ID"]
        textField.tap()
        textField.typeText(userid)
        app.buttons["Register Player"].tap()
        sleep(networkWaiting)
        XCTAssert(app.staticTexts[username].exists)
    }
    
    /// Test all hero page
    func testHeroPage() {
        let app = startApp()
        app.buttons["Heroes"].tap()
        let abaddonButton = app.buttons["Abaddon"]
        XCTAssert(abaddonButton.exists)
        takeScreenshot("Hero")
        abaddonButton.tap()
        let borrowedTimeButton = app.buttons["abaddon_borrowed_time"]
        XCTAssert(borrowedTimeButton.exists)
        takeScreenshot("Hero Detail")
        if UIDevice.current.userInterfaceIdiom == .phone {
            borrowedTimeButton.tap()
            sleep(networkWaiting)
            takeScreenshot("Ability Detail")
        }
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
        textField.typeText(username)
        sleep(networkWaiting)
        // click enter on software keyboard
        app.keyboards.buttons["search"].tap()
        sleep(networkWaiting)
        app.buttons[userid].tap()
        sleep(networkWaiting)
        app.buttons["favourite"].tap()
        if UIDevice.current.userInterfaceIdiom == .pad {
            app.buttons["Home"].tap()
        } else {
            app.tabBars["Tab Bar"].buttons["Home"].tap()
        }
        XCTAssert(app.staticTexts[username].exists)
    }
}
