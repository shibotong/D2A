//
//  OpenDotaConstantProviderTests.swift
//  Unit Tests
//
//  Created by Shibo Tong on 22/7/2025.
//

import XCTest
@testable import D2A

final class OpenDotaConstantProviderTests: XCTestCase {
    
    var provider: OpenDotaConstantProviding!

    override func setUp() {
        let fetcher = MockOpenDotaConstantFetcher()
        provider = OpenDotaConstantProvider(fetcher: fetcher)
    }
    
    func testProvider() async {
        let abilities = await provider.loadAbilities()
        XCTAssert(abilities.count > 0, "Provider should return at least one ability")
        let heroes = await provider.loadHeroes()
        XCTAssert(heroes.count > 0, "Provider should return at least one hero")
    }
}
