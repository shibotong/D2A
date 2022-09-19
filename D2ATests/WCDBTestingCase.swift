//
//  WCDBTestingCase.swift
//  AppTests
//
//  Created by Shibo Tong on 11/6/2022.
//

@testable import D2A
import XCTest


class WCDBTestingCase: XCTestCase {
    
    var wcdbController: WCDBController!
    var decodingService: DecodingService!
    
    override func setUp() {
        super.setUp()
        self.wcdbController = WCDBController()
        self.wcdbController.deleteDatabase()
        self.decodingService = DecodingService()
    }
    
    override func tearDown() {
        self.wcdbController.deleteDatabase() // delete database when teardown
        self.wcdbController = nil
        self.decodingService = nil
        super.tearDown()
    }

    func testUserSearch() async throws {
        let searchText = "MR.BOBOBO"
        let playerID = "153041957"
        let data = try! await decodingService.loadData("/players/\(playerID)")
        let profile: UserProfile = try! decodingService.decodeUserProfile(data)
        try wcdbController.database.insert(objects: profile, intoTable: "UserProfile")
        let profiles = wcdbController.fetchUserProfile(userName: searchText)
        XCTAssertEqual(profiles.count, 1)
    }
}
