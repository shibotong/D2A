//
//  ScreenShotTests.swift
//  D2AUITests
//
//  Created by Shibo Tong on 22/4/2023.
//

import XCTest

final class ScreenShotTests: XCTestCase {
    
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
        textField.typeText(userID)
        app.buttons["Register Player"].tap()
        sleep(networkWaiting)
        takeScreenshot("Home")
        
        // Take screenshot for Hero List
        app.buttons["Heroes"].tap()
        let abaddonButton = app.buttons[hero]
        takeScreenshot("Hero List")
        abaddonButton.tap()
        let borrowedTimeButton = app.buttons[ability]
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
        searchTextField.typeText(userName)
        sleep(networkWaiting)
        // click enter on software keyboard
        app.keyboards.buttons["search"].tap()
        sleep(networkWaiting)
        takeScreenshot("Search")
        app.buttons[userID].tap()
        sleep(networkWaiting)
        takeScreenshot("Profile")
        app.buttons["All"].tap()
        app.buttons["Month"].tap()
        let datePicker = app.datePickers
        datePicker.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: "2023")
        sleep(1)
        datePicker.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: "March")
        app.buttons["Month"].tap()
        app.buttons["Thursday, March 30"].tap()
        takeScreenshot("Calendar")
        
        // use a match id on that date
        app.buttons["7084211966"].tap()
        sleep(networkWaiting)
        takeScreenshot("Match Detail")
    }
}
