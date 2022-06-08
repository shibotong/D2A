//
//  DataTransferTestCase.swift
//  AppTests
//
//  Created by Shibo Tong on 6/6/2022.
//

@testable import App
import XCTest

class DataTransferTestCase: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRankTransfer() {
        let unrank = DataHelper.transferRank(rank: nil)
        XCTAssertEqual(unrank, "Unranked")
        let herald = DataHelper.transferRank(rank: 11)
        XCTAssertEqual(herald, "Herald 1")
        let guardian = DataHelper.transferRank(rank: 22)
        XCTAssertEqual(guardian, "Guardian 2")
        let crusader = DataHelper.transferRank(rank: 33)
        XCTAssertEqual(crusader, "Crusader 3")
        let archon = DataHelper.transferRank(rank: 44)
        XCTAssertEqual(archon, "Archon 4")
        let legend = DataHelper.transferRank(rank: 55)
        XCTAssertEqual(legend, "Legend 5")
        let ancient = DataHelper.transferRank(rank: 61)
        XCTAssertEqual(ancient, "Ancient 1")
        let divine = DataHelper.transferRank(rank: 72)
        XCTAssertEqual(divine, "Divine 2")
        let immortal = DataHelper.transferRank(rank: 80)
        XCTAssertEqual(immortal, "Immortal")
        
    }
}
