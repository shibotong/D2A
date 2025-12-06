//
//  UnitTestError.swift
//  D2A
//
//  Created by Shibo Tong on 6/12/2025.
//

struct UnitTestError: Error {
    
    let error: UnitTestErrorType
    
    init(_ error: UnitTestErrorType) {
        self.error = error
    }
}

enum UnitTestErrorType {
    case dataNotProvided
}
