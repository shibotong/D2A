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
    private let fetcher: MockStoreFetcher

    init() {
        fetcher = MockStoreFetcher()
        store = StoreManager(storeFetcher: fetcher)
    }
    
    @Test
    func `Test no product found`() async {
        fetcher.fetchProductsReturnValue = []
        await store.setupStore()
        #expect(store.product == nil)
    }
    
    @Test
    func `Test failed to load product`() async {
        fetcher.fetchProductsClosure = { _ in
            throw StoreError.unknown
        }
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
    
    @Test("Test restore purchase is called when restoring purchase")
    func restorePurchase() async throws {
        await setupStore(product: MockProduct(result: .userCancelled))
        await store.restorePurchase()
        #expect(fetcher.restorePurchaseCount == 1)
    }
    
    private func setupStore(product: MockProduct) async {
        fetcher.fetchProductsReturnValue = [product]
        await store.setupStore()
    }
}

private class MockStoreFetcher: StoreFetching {
    
    var fetchProductsReturnValue: [any StoreProduct]!
    var fetchProductsClosure: (([String]) async throws -> [any StoreProduct])?
    
    func fetchProducts(productIDs: [String]) async throws -> [any D2A.StoreProduct] {
        if let fetchProductsClosure {
            return try await fetchProductsClosure(productIDs)
        }
        return fetchProductsReturnValue
    }
    
    func transactionListener(handler: nonisolated(nonsending) @escaping (D2A.StoreVerificationResult) async throws -> Void) async {
        return
    }
    
    var restorePurchaseCount = 0
    
    func restorePurchase() async throws {
        restorePurchaseCount += 1
    }
}
