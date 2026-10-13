//
//  D2AError.swift
//  D2A
//
//  Created by Shibo Tong on 1/8/2026.
//

import Foundation

struct D2AError: LocalizedError {
    enum Category: String {
        case image
        case store
        case network
        #if DEBUG
        case mock
        #endif
    }
    
    let category: Category
    let message: String
    
    var errorDescription: String? {
        return NSLocalizedString(message, comment: "error messages")
    }
}
