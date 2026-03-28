//
//  DataSyncingLogger.swift
//  D2A
//
//  Created by Shibo Tong on 28/3/2026.
//

actor DataSyncingLogger {
    var errors: [SyncingError] = []
    
    struct SyncingError {
        let type: ErrorDataType
        let error: ErrorType
        let key: String
    }
    
    func addError(type: ErrorDataType, error: ErrorType, key: String) {
        errors.append(SyncingError(type: type, error: error, key: key))
    }
    
    enum ErrorDataType {
        case ability
    }
    
    enum ErrorType {
        case dataType
    }
}
