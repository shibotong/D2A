//
//  StoreError.swift
//  D2A
//
//  Created by Shibo Tong on 2/9/2026.
//

enum StoreError {
    static let failedVerification = D2AError(category: .store, message: "Verification failed")
    static let userCancelled = D2AError(category: .store, message: "Cancelled transaction")
    static let unknown = D2AError(category: .store, message: "Unknown error")
}
