//
//  OpenDotaConstantsTests.swift
//  D2A
//
//  Created by Shibo Tong on 9/6/2025.
//

import XCTest

@testable import D2A

final class OpenDotaConstantsTests: XCTestCase {
    var constantProvider: OpenDotaConstantProviding!

    override func setUp() {
        constantProvider = OpenDotaConstantProvider()
    }

    func testLoadingOpenDotaHeroes() async {
        let heroes = await constantProvider.loadHeroes()
        XCTAssertNotEqual(heroes.count, 0, "Failed to load heroes")
    }
}
