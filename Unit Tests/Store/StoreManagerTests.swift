//
//  StoreManagerTests.swift
//  D2A
//
//  Created by Shibo Tong on 5/9/2026.
//

@testable import D2A
import Testing

struct StoreManagerTests {
    
    private let store: StoreManager
    private let fetcher: StoreFetchingMock

    init() {
        fetcher = StoreFetchingMock()
        store = StoreManager(storeFetcher: fetcher)
    }
    
    @Test
    func `Test no product found`() async {
        fetcher._fetchProducts.implementation = .returns([])
        await store.setupStore()
        #expect(store.product == nil)
    }
    
    @Test
    func `Test failed to load product`() async {
        fetcher._fetchProducts.implementation = .throws(StoreError.unknown)
        await store.setupStore()
        #expect(store.product == nil)
    }
    
    @Test("Test purchase product with user cancellation", arguments: [MockProduct(result: .userCancelled)])
    func purchaseUserCancel(product: MockProduct) async throws {
        await setupStore(product: product)
        await store.purchase()
        #expect(store.errorIsPresented == true)
    }
    
    @Test("Test purchase product with pending", arguments: [MockProduct(result: .pending)])
    func purchasePending(product: MockProduct) async throws {
        await setupStore(product: product)
        await store.purchase()
        #expect(store.errorIsPresented == false)
    }
    
    private func setupStore(product: MockProduct) async {
        fetcher._fetchProducts.implementation = .returns([product])
        await store.setupStore()
    }
}
