//
//  PreviewStoreFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 5/9/2026.
//

struct PreviewStoreFetcher: StoreFetching {
    
    init(products: [any StoreProduct] = [PreviewStoreProduct.success]) {
        self.products = products
    }
    
    let products: [any StoreProduct]
    
    func fetchProducts(productIDs: [String]) async throws -> [any StoreProduct] {
        return products
    }
    
    func transactionListener(handler: nonisolated(nonsending) (StoreVerificationResult) async throws -> Void) async {
        return
    }
}
