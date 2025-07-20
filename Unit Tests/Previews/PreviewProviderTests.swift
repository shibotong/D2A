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
    
    let heroes = provider.heroes
    #expect(heroes.count == 10, "Preview provider should have 10 heroes")
}
