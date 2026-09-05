//
//  StoreVerificationResult.swift
//  D2A
//
//  Created by Shibo Tong on 5/9/2026.
//

import StoreKit

enum StoreVerificationResult {
    case unverified
    case verified(StoreTransaction)
    
    init(result: VerificationResult<Transaction>) {
        switch result {
        case .unverified(let signedType, let verificationError):
            self = .unverified
        case .verified(let signedType):
            self = .verified(signedType)
        }
    }
    
    func verify() throws -> StoreTransaction {
        switch self {
        case .unverified:
            // StoreKit has parsed the JWS but failed verification. Don't deliver content to the user.
            throw StoreError.failedVerification
        case .verified(let safe):
            // If the transaction is verified, unwrap and return it.
            return safe
        }
    }
}
