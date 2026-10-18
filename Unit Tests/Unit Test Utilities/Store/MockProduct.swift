//
//  MockProduct.swift
//  D2A
//
//  Created by Shibo Tong on 8/9/2026.
//

@testable import D2A

struct MockProduct: StoreProduct {
    let displayPrice: String = "$0.99"
    
    let result: StorePurchaseResult
    
    func purchase() async throws -> D2A.StorePurchaseResult {
        return result
    }
}
