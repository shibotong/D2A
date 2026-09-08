//
//  StoreFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 2/9/2026.
//

import StoreKit
import Logging

protocol StoreFetching: Sendable {
    @concurrent
    func fetchProducts(productIDs: [String]) async throws -> [StoreProduct]
        
    func transactionListener(handler: (StoreVerificationResult) async throws -> Void) async
    
    func restorePurchase() async throws(D2AError)
}

struct StoreFetcher: StoreFetching {
    
    private let logger: Logger?
    
    init(logger: Logger? = D2ALogger.storeManager) {
        self.logger = logger
    }
    
    @concurrent
    func fetchProducts(productIDs: [String]) async throws -> [StoreProduct] {
        return try await Product.products(for: productIDs)
    }
    
    func transactionListener(handler: (StoreVerificationResult) async throws -> Void) async {
        for await result in Transaction.updates {
            let verificationResult = StoreVerificationResult(result: result)
            try? await handler(verificationResult)
        }
    }
    
    func restorePurchase() async throws(D2AError) {
        do {
            try await AppStore.sync()
        } catch {
            logger?.error("Failed to restore purchase \(error)")
            throw StoreError.restorePurchaseFailed
        }
    }
}

