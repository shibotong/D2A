//
//  DataSyncingLogger.swift
//  D2A
//
//  Created by Shibo Tong on 28/3/2026.
//

actor DataSyncingLogger {
    var errors: [SyncingError] = []
    
    struct SyncingError {
        let type: DataType
        let error: ErrorType
        let key: String
    }
    
    func addError(type: DataType, error: ErrorType, key: String) {
        errors.append(SyncingError(type: type, error: error, key: key))
    }
    
    enum DataType {
        case ability
        case hero
    }
    
    enum ErrorType {
        case dataType
    }
}
