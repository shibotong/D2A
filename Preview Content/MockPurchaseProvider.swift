//
//  MockPurchaseProvider.swift
//  D2A
//
//  Created by Shibo Tong on 20/9/2025.
//

import Foundation

class MockPurchaseProvider: PurchaseProviding {
    var isPro = true
    
    init(isPro: Bool = true) {
        self.isPro = isPro
    }
    
    func setPro(_ isPro: Bool) {
        self.isPro = isPro
        NotificationCenter.isPro.send(isPro)
    }
}
