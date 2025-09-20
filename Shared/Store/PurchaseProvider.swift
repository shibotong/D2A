//
//  PurchaseProvider.swift
//  D2A
//
//  Created by Shibo Tong on 20/9/2025.
//

import Foundation

protocol PurchaseProviding {
    var isPro: Bool { get }
    func setPro(_ isPro: Bool)
}

class PurchaseProvider: PurchaseProviding {
    
    static let shared = PurchaseProvider()
    
    var isPro: Bool {
        didSet {
            userDefaults.set(isPro, forKey: UserDefaults.subscription)
        }
    }
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .group) {
        self.userDefaults = userDefaults
        isPro = userDefaults.bool(forKey: UserDefaults.subscription)
    }
    
    func setPro(_ isPro: Bool) {
        self.isPro = isPro
        NotificationCenter.isPro.send(isPro)
    }
}
