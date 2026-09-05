//
//  StoreTransaction.swift
//  D2A
//
//  Created by Shibo Tong on 5/9/2026.
//

import StoreKit

protocol StoreTransaction {
    func finish() async
}

extension Transaction: StoreTransaction {
    
}

