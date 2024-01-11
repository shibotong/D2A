//
//  D2AUITests.swift
//  D2AUITests
//
//  Created by Shibo Tong on 17/3/2023.
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

final class D2AUITests: XCTestCase {

    override func setUpWithError() throws {
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeRight
        }
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
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
        textField.typeText(userID)
        app.buttons["Register Player"].tap()
        sleep(networkWaiting)
        XCTAssert(app.staticTexts[userName].exists)
    }
    
    /// Test all hero page
    func testHeroPage() {
        let app = startApp()
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = UIDeviceOrientation.landscapeLeft
            sleep(1)
        }
        app.buttons["Heroes"].tap()
        let heroButton = app.buttons[hero]
        XCTAssert(heroButton.exists)
        takeScreenshot("Hero")
        heroButton.tap()
        sleep(networkWaiting)
        let abilityButton = app.buttons[ability]
        XCTAssert(abilityButton.exists)
        takeScreenshot("Hero Detail")
        if UIDevice.current.userInterfaceIdiom == .phone {
            abilityButton.tap()
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
        textField.typeText(userName)
        sleep(networkWaiting)
        // click enter on software keyboard
        app.keyboards.buttons["search"].tap()
        sleep(networkWaiting)
        app.buttons[userID].tap()
        sleep(networkWaiting)
        app.buttons["favourite"].tap()
        if UIDevice.current.userInterfaceIdiom == .pad {
            app.buttons["Home"].tap()
        } else {
            app.tabBars["Tab Bar"].buttons["Home"].tap()
        }
        XCTAssert(app.staticTexts[userName].exists)
    }
}
