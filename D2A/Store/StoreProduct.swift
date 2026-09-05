//
//  StoreProduct.swift
//  D2A
//
//  Created by Shibo Tong on 2/9/2026.
//

import StoreKit

protocol StoreProduct {
    func purchase() async throws -> StorePurchaseResult
}

extension Product: StoreProduct {
    func purchase() async throws -> StorePurchaseResult {
        let result = try await self.purchase(options: [])
        switch result {
        case .success(let verificationResult):
            return .success(StoreVerificationResult(result: verificationResult))
        case .userCancelled:
            return .userCancelled
        case .pending:
            return .pending
        @unknown default:
            fatalError()
        }
    }
}
