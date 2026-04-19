//
//  NSManagedObject.swift
//  D2A
//
//  Created by Shibo Tong on 27/1/2026.
//

import CoreData

func setIfNotEqual<T: Any, V: Equatable>(entity: T, path: ReferenceWritableKeyPath<T, V>, value: V) {
    if entity[keyPath: path] != value {
        entity[keyPath: path] = value
    }
}

func setIfExist<T: Any, V: Equatable>(entity: T, path: ReferenceWritableKeyPath<T, V>, data: [String: Any], key: String, defaultValue: V? = nil, errorCompletion: ((String) -> ())? = nil) {
    guard let value = data[key] else {
        return
    }
    
    guard let value = value as? V else {
        guard let value = value as? NSNull, let defaultValue else {
            errorCompletion?(key)
            return
        }
        setIfNotEqual(entity: entity, path: path, value: defaultValue)
        return
    }
    setIfNotEqual(entity: entity, path: path, value: value)
}
