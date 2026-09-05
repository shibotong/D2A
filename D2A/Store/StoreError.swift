//
//  StoreError.swift
//  D2A
//
//  Created by Shibo Tong on 2/9/2026.
//

enum StoreError {
    static let failedVerification = D2AError(category: .store, message: "VerificationFailed")
    static let userCancelled = D2AError(category: .store, message: "TransactionCancelled")
    static let unknown = D2AError(category: .store, message: "Unknown")
}
