//
//  PreviewStoreProduct.swift
//  D2A
//
//  Created by Shibo Tong on 5/9/2026.
//

struct PreviewStoreProduct: StoreProduct {
    let displayPrice: String = "$0.99"
    
    func purchase() async throws -> StorePurchaseResult {
        try await Task.sleep(for: .seconds(1))
        return .success(.verified(PreviewStoreTransaction()))
    }
}
