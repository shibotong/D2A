//
//  StorePurchaseResult.swift
//  D2A
//
//  Created by Shibo Tong on 5/9/2026.
//

import StoreKit

enum StorePurchaseResult {
    case success(StoreVerificationResult)
    case userCancelled
    case pending
}
