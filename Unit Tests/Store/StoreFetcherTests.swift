//
//  StoreFetcherTests.swift
//  D2A
//
//  Created by Shibo Tong on 2/9/2026.
//

import Testing
import StoreKitTest
@testable import D2A

@Suite(.disabled())
struct StoreFetcherTests {
    
    let fetcher: StoreFetcher
    let session: SKTestSession
    
    init() throws {
        fetcher = StoreFetcher()
        session = try SKTestSession(configurationFileNamed: "StoreConfiguration")
    }
    
    @Test
    func `Fetch products`() async throws {
        let products = try await fetcher.fetchProducts(productIDs: ["D2APRO"])
        #expect(products.count == 1)
    }
}
