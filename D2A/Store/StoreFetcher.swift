//
//  StoreFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 2/9/2026.
//

import StoreKit
import Logging
import Mocking

@Mocked(compilationCondition: .debug)
protocol StoreFetching: Sendable {
    @concurrent
    func fetchProducts(productIDs: [String]) async throws -> [StoreProduct]
        
    func transactionListener(handler: @escaping (StoreVerificationResult) async throws -> Void) async
    
    func restorePurchase() async throws
}

struct StoreFetcher: StoreFetching {
    
    private let logger: D2ALogger
    
    init(logger: D2ALogger = .shared) {
        self.logger = logger
    }
    
    @concurrent
    func fetchProducts(productIDs: [String]) async throws -> [StoreProduct] {
        return try await Product.products(for: productIDs)
    }
    
    func transactionListener(handler: @escaping (StoreVerificationResult) async throws -> Void) async {
        for await result in Transaction.updates {
            let verificationResult = StoreVerificationResult(result: result)
            try? await handler(verificationResult)
        }
    }
    
    func restorePurchase() async throws {
        do {
            try await AppStore.sync()
        } catch {
            logger.error("Failed to restore purchase \(error)", category: .store)
            throw StoreError.restorePurchaseFailed
        }
    }
}

