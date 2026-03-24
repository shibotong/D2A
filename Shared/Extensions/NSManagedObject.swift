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

func setIfExist<T: Any, V: Equatable>(entity: T, path: ReferenceWritableKeyPath<T, V>, data: [String: Any], key: String, localization: V? = nil) {
    if let localization {
        setIfNotEqual(entity: entity, path: path, value: localization)
        return
    }
    guard let value = data[key] as? V else {
        return
    }
    setIfNotEqual(entity: entity, path: path, value: value)
}
