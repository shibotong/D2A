//
//  DecodingTestService.swift
//  AppTests
//
//  Created by Shibo Tong on 1/4/2022.
//

import XCTest

@testable import D2A

class DecodingTestCase: XCTestCase {

  var decodingService: DecodingService!

  override func setUp() {
    super.setUp()
    decodingService = DecodingService()
  }

  override func tearDown() {
    decodingService = nil
    super.tearDown()
  }
  //
  //    func testDecodingRecentMatches() async throws {
  //        let playerID = "153041957"
  //        let data = try await decodingService.loadData("/players/\(playerID)/matches?significant=0")
  //        let recentMatches = try decodingService.decodeRecentMatch(data)
  //        XCTAssertNotEqual(recentMatches.count, 0)
  //    }
  //
  //    func testDecodingUserProfile() async throws {
  //        let playerID = "153041957"
  //        let data = try await decodingService.loadData("/players/\(playerID)")
  //        XCTAssertNoThrow(try decodingService.decodeUserProfile(data))
  //    }
}
