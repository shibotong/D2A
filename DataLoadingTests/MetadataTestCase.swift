//
//  MetadataTestCase.swift
//  AppTests
//
//  Created by Shibo Tong on 15/5/2022.
//

@testable import D2A
import XCTest
import Combine

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
//    func testLoadingHeroDatabase() {
//        let expectation = self.expectation(description: "loading hero data")
//        let heroDatabase = HeroDatabase()
//        var databaseStatus: LoadingStatus?
//        cancellable = heroDatabase.$status.sink { status in
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
