//
//  StoreFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 2/9/2026.
//

import StoreKit

protocol StoreFetching: Sendable {
    @concurrent
    func fetchProducts(productIDs: [String]) async throws -> [Product]
    
    func purchase(product: Product) async throws -> Transaction?
    
    func transactionListener(handler: (Transaction) -> Void) async
}

struct StoreFetcher: StoreFetching {
    @concurrent
    func fetchProducts(productIDs: [String]) async throws -> [Product] {
        return try await Product.products(for: productIDs)
    }
    
    func purchase(product: Product) async throws -> Transaction? {
        let result = try await product.purchase()

        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            return transaction
        case .userCancelled:
            throw StoreError.userCancelled
        case .pending:
            return nil
        @unknown default:
            throw StoreError.unknown
        }
    }
    
    func transactionListener(handler: (Transaction) -> Void) async {
        for await result in Transaction.updates {
            do {
                let transaction = try checkVerified(result)

                // Deliver content to the user.
                handler(transaction)

                // Always finish a transaction.
                await transaction.finish()
            } catch {
                // StoreKit has a receipt it can read but it failed verification. Don't deliver content to the user.
                print("Transaction failed verification")
            }
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        // Check if the transaction passes StoreKit verification.
        switch result {
        case .unverified:
            // StoreKit has parsed the JWS but failed verification. Don't deliver content to the user.
            throw StoreError.failedVerification
        case .verified(let safe):
            // If the transaction is verified, unwrap and return it.
            return safe
        }
    }
}

