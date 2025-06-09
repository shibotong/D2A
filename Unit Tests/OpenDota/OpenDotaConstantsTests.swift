//
//  OpenDotaConstantsTests.swift
//  Unit Tests
//
//  Created by Shibo Tong on 9/6/2025.
//

import Testing

@testable import D2A

struct OpenDotaConstantsTests {

    var constantsProvider: OpenDotaConstantProviding = OpenDotaConstantProvider()

    @Test
    func loadHeroes() async {
        let heroes = await constantsProvider.loadHeroes()
        #expect(heroes.count > 0, "Heroes list should not be empty")
    }

    @Test
    func <#name#>() async throws {
        <#body#>
    }
}
