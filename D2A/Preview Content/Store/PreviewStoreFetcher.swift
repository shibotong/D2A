//
//  PreviewStoreFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 5/9/2026.
//

struct PreviewStoreFetcher: StoreFetching {
    func fetchProducts(productIDs: [String]) async throws -> [any StoreProduct] {
        return [PreviewStoreProduct()]
    }
    
    func transactionListener(handler: nonisolated(nonsending) (StoreVerificationResult) async throws -> Void) async {
        return
    }
}
