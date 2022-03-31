//
//  DecodingTestService.swift
//  AppTests
//
//  Created by Shibo Tong on 1/4/2022.
//

@testable import App
import XCTest


class DecodingTestService: XCTestCase {
    
    var decodingService: DecodingService!
    
    override func setUp() {
        super.setUp()
        self.decodingService = DecodingService()
    }
    
    override func tearDown() {
        decodingService = nil
        super.tearDown()
    }
    
    func testDecodingMatches() async throws {
        let newMatchID  = "6502094960"
        let oldMatchID  = "1008064790"
        let failMatchID = "1534151234"
        let newData = try! await decodingService.loadData("/matches/\(newMatchID)")
        XCTAssertNoThrow(try decodingService.decodeMatch(data: newData))
        let oldData = try! await decodingService.loadData("/matches/\(oldMatchID)")
        XCTAssertNoThrow(try decodingService.decodeMatch(data: oldData))
        let failData = try! await decodingService.loadData("/matches/\(failMatchID)")
        XCTAssertThrowsError(try decodingService.decodeMatch(data: failData))
    }
    
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
