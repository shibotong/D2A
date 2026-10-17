//
//  PreviewStoreProduct.swift
//  D2A
//
//  Created by Shibo Tong on 5/9/2026.
//

struct PreviewStoreProduct: StoreProduct {
    
    static let success = PreviewStoreProduct()
    static let userCancelled = PreviewStoreProduct(result: .userCancelled)
    static let pending = PreviewStoreProduct(result: .pending)
    
    let displayPrice: String = "$0.99"
    
    private let result: StorePurchaseResult
    
    init(result: StorePurchaseResult = .success(.verified(PreviewStoreTransaction()))) {
        self.result = result
    }
    
    func purchase() async throws -> StorePurchaseResult {
        try await Task.sleep(for: .seconds(1))
        return result
    }
}
