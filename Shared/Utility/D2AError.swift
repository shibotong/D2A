//
//  D2AError.swift
//  D2A
//
//  Created by Shibo Tong on 28/11/2025.
//

import Foundation

struct D2AError: LocalizedError {
    let description: String
    
    var errorDescription: String? {
        description
    }
}
