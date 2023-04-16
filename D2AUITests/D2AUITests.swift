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
    func testRegister() {
        let app = startApp()
        let textField = app.textFields["Search ID"]
        textField.tap()
        textField.typeText("153041957")
        app.buttons["Register Player"].tap()
        sleep(networkWaiting)
        XCTAssert(app.staticTexts["Mr.BOBOBO"].exists)
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
        textField.typeText("Mr.BOBOBO")
        sleep(networkWaiting)
        // click enter on software keyboard
        app.keyboards.buttons["search"].tap()
        sleep(networkWaiting)
        app.buttons["153041957"].tap()
        sleep(networkWaiting)
        app.buttons["favourite"].tap()
        if UIDevice.current.userInterfaceIdiom == .pad {
            app.buttons["Home"].tap()
        } else {
            app.tabBars["Tab Bar"].buttons["Home"].tap()
        }
        XCTAssert(app.staticTexts["Mr.BOBOBO"].exists)
    }
    
    /// Take screenshots for each devices
    func testCaptureSnapshots() {
        // Take screenshot on home page
        let app = startApp()
        let textField = app.textFields["Search ID"]
        textField.tap()
        textField.typeText("153041957")
        app.buttons["Register Player"].tap()
        sleep(networkWaiting)
        takeScreenshot("Home")
        
        // Take screenshot for Hero List
        app.buttons["Heroes"].tap()
        let abaddonButton = app.buttons["Abaddon"]
        takeScreenshot("Hero List")
        abaddonButton.tap()
        let borrowedTimeButton = app.buttons["abaddon_borrowed_time"]
        takeScreenshot("Hero Detail")
        if UIDevice.current.userInterfaceIdiom == .phone {
            borrowedTimeButton.tap()
            sleep(networkWaiting)
            takeScreenshot("Ability Detail")
        }
        
        // Take screenshot for search page
        if UIDevice.current.userInterfaceIdiom == .pad {
            app.buttons["Search"].tap()
        } else {
            app.tabBars["Tab Bar"].buttons["Search"].tap()
        }
        let searchTextField = app.searchFields["Players, Heroes, Matches"]
        searchTextField.tap()
        searchTextField.typeText("Mr.BOBOBO")
        sleep(networkWaiting)
        // click enter on software keyboard
        app.keyboards.buttons["search"].tap()
        sleep(networkWaiting)
        takeScreenshot("Search")
        app.buttons["153041957"].tap()
        sleep(networkWaiting)
        takeScreenshot("Profile")
        app.buttons["All"].tap()
        app.buttons["Month"].tap()
        let datePicker = app.datePickers
        datePicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "March")
        datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "2023")
        app.buttons["Month"].tap()
        app.buttons["Thursday, March 30"].tap()
        takeScreenshot("Calendar")
        app.buttons["7084211966"].tap()
        sleep(networkWaiting)
        takeScreenshot("Match Detail")
    }
    
    private func startApp() -> XCUIApplication {
        let app = XCUIApplication()
        app.launchArguments = ["uitest"]
        app.launch()
        sleep(5)
        return app
    }

    private func takeScreenshot(_ name: String? = nil) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot)
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
