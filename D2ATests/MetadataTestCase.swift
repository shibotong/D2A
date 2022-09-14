//
//  MetadataTestCase.swift
//  AppTests
//
//  Created by Shibo Tong on 15/5/2022.
//

@testable import App
import XCTest

class MetadataTestCase: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDecodingHeroAbilities() async {
        let abilities = await loadAbilities()
        XCTAssertNotEqual(abilities.count, 0)
    }
    
    func testDecodingHeroes() async {
        let abilities = await loadHeroAbilities()
        XCTAssertNotEqual(abilities.count, 0)
    }
    
    func testDecodingTalents() async {
        let talents = await loadTalentData()
        XCTAssertNotEqual(talents.count, 0)
    }

    func testHeroScepter() async {
        let scepter = await loadScepter()
        XCTAssertNotEqual(scepter.count, 0)
    }
}
