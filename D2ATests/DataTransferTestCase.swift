//
//  DataTransferTestCase.swift
//  AppTests
//
//  Created by Shibo Tong on 6/6/2022.
//

@testable import D2A
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
        XCTAssertEqual(herald, "Herald I")
        let guardian = DataHelper.transferRank(rank: 22)
        XCTAssertEqual(guardian, "Guardian II")
        let crusader = DataHelper.transferRank(rank: 33)
        XCTAssertEqual(crusader, "Crusader III")
        let archon = DataHelper.transferRank(rank: 44)
        XCTAssertEqual(archon, "Archon IV")
        let legend = DataHelper.transferRank(rank: 55)
        XCTAssertEqual(legend, "Legend V")
        let ancient = DataHelper.transferRank(rank: 61)
        XCTAssertEqual(ancient, "Ancient I")
        let divine = DataHelper.transferRank(rank: 72)
        XCTAssertEqual(divine, "Divine II")
        let immortal = DataHelper.transferRank(rank: 80)
        XCTAssertEqual(immortal, "Immortal")
        
    }
}
