//
//  DecodingTestService.swift
//  AppTests
//
//  Created by Shibo Tong on 1/4/2022.
//

@testable import D2A
import XCTest


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
    
//    func testLoadingMatches() async throws {
//        let matchID = "1008064790"
//        XCTAssertNoThrow(try await decodingService.loadData("/matches/\(matchID)"))
//    }
//    
//    func testDecodingMatches() async throws {
//        let newMatchID  = "6769316783"
//        let oldMatchID  = "1008064790"
//        let newData = try! await decodingService.loadData("/matches/\(newMatchID)")
//        XCTAssertNoThrow(try decodingService.decodeMatch(data: newData))
//        let oldData = try! await decodingService.loadData("/matches/\(oldMatchID)")
//        XCTAssertNoThrow(try decodingService.decodeMatch(data: oldData))
//    }
//    
    func testDecodingRecentMatches() async throws {
        let playerID = "153041957"
        let data = try! await decodingService.loadData("/players/\(playerID)/matches?significant=0")
        let recentMatches = try decodingService.decodeRecentMatch(data)
        XCTAssertNotEqual(recentMatches.count, 0)
    }
    
    func testDecodingUserProfile() async throws {
        let playerID = "153041957"
        let data = try! await decodingService.loadData("/players/\(playerID)")
        XCTAssertNoThrow(try decodingService.decodeUserProfile(data))
    }
}
