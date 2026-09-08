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

    init() {
        store = StoreManager()
    }
    
    @Test("Don't purchase if no product is loaded")
    func testDontPurchase() async {
        let store = StoreManager()
        await store.purchase()
        #expect(store.isPurchased == false)
        #expect(store.errorIsPresented == false)
        #expect(store.error == nil)
    }
    
    @Test("Test purchase product with user cancellation", arguments: [MockProduct(result: .userCancelled)])
    func purchaseUserCancel(product: MockProduct) async throws {
        let store = StoreManager(product: product)
        await store.purchase()
        #expect(store.errorIsPresented == true)
    }
    
    @Test("Test purchase product with pending", arguments: [MockProduct(result: .pending)])
    func purchasePending(product: MockProduct) async throws {
        let store = StoreManager(product: product)
        await store.purchase()
        #expect(store.errorIsPresented == false)
    }
}
