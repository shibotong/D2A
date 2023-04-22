//
//  ScreenShotTests.swift
//  D2AUITests
//
//  Created by Shibo Tong on 22/4/2023.
//

import XCTest

final class ScreenShotTests: XCTestCase {
    
    private let networkWaiting: UInt32 = 3

    override func setUpWithError() throws {
        if UIDevice.current.userInterfaceIdiom == .pad {
            XCUIDevice.shared.orientation = .landscapeRight
        }
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
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

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
