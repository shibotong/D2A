//
//  PreviewProviderTests.swift
//  D2A
//
//  Created by Shibo Tong on 20/7/2025.
//

import Testing
@testable import D2A

@Test
func testPreviewProvider() {
    let provider = PreviewDataProvider()
    #expect(provider.odHeroes.count == 10, "Preview provider should have 10 heroes")
    #expect(provider.odAbilities.count == 137, "Preview provider should have 137 abilities")
    #expect(provider.odAbilityIDs.count != 0, "Preview provider ability IDs should not be 0")
}
