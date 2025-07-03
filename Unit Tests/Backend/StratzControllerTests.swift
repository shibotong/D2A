//
//  StratzControllerTests.swift
//  D2A
//
//  Created by Shibo Tong on 3/7/2025.
//

import XCTest
@testable import D2A

final class StratzControllerTests: XCTestCase {
    
    var stratzController: StratzController!
    var userDefaults: UserDefaults!
    var notification: D2ANotificationCenter!
    
    override func setUp()  {
        notification = D2ANotificationCenter()
        userDefaults = UserDefaults(suiteName: "UnitTest")!
        stratzController = StratzController(notification: notification, userDefault: userDefaults)
    }
    
    func testApolloClientCreation() async {
        XCTAssertNil(stratzController.apollo, "Apollo client should be nil when no stored token in user defaults")
        
        notification.stratzToken.send("test token")
        
        XCTAssertNotNil(stratzController.apollo, "Apollo client should not be nil when sending a non-empty token")
        
        notification.stratzToken.send("")
        
        XCTAssertNil(stratzController.apollo, "Apollo client should be nil when set token to empty")
    }
    
    func testApolloClientCreationAtBeginning() {
        userDefaults.set("test token", forKey: UserDefaults.stratzToken)
        stratzController = StratzController(notification: notification, userDefault: userDefaults)
        XCTAssertNotNil(stratzController.apollo, "Apollo client should not be nil when has stored token")
        userDefaults.set(nil, forKey: UserDefaults.stratzToken)
    }
}
