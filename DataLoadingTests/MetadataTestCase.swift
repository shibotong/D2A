//
//  MetadataTestCase.swift
//  AppTests
//
//  Created by Shibo Tong on 15/5/2022.
//

import Combine
import XCTest

@testable import D2A

class MetadataTestCase: XCTestCase {

    private var cancellable: AnyCancellable?

    override func tearDown() {
        cancellable = nil
    }

    //    func testDecodingHeroAbilities() async {
    //        let abilities = await loadAbilities()
    //        XCTAssertNotEqual(abilities.count, 0)
    //    }
    //
    //    func testDecodingHeroes() async {
    //        let abilities = await loadHeroAbilities()
    //        XCTAssertNotEqual(abilities.count, 0)
    //    }
    //
    //    func testHeroScepter() async {
    //        let scepter = await loadScepter()
    //        XCTAssertNotEqual(scepter.count, 0)
    //    }
    //
    //    func testLoadingConstantsController() {
    //        let expectation = self.expectation(description: "loading hero data")
    //        let ConstantsController = ConstantsController()
    //        var databaseStatus: LoadingStatus?
    //        cancellable = ConstantsController.$status.sink { status in
    //            switch status {
    //            case .loading:
    //                break
    //            default:
    //                databaseStatus = status
    //                expectation.fulfill()
    //            }
    //        }
    //        waitForExpectations(timeout: 60)
    //        XCTAssertEqual(databaseStatus, .finish)
    //    }
}
