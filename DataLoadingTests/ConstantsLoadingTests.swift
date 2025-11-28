//
//  ConstantsLoadingTests.swift
//  D2A
//
//  Created by Shibo Tong on 28/11/2025.
//

import Testing
@testable import D2A

struct ConstantsLoadingTests {
    
    let dataProvider: OpenDotaProvider = .shared
    
    @Test
    func loadHeroes() async throws {
        let heroes = try await dataProvider.constants(service: .heroes)
    }
    
}
