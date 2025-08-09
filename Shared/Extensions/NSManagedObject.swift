//
//  NSManagedObject.swift
//  D2A
//
//  Created by Shibo Tong on 1/5/2025.
//

import CoreData

func setIfNotEqual<T: Any, V: Equatable>(entity: T, path: ReferenceWritableKeyPath<T, V>, value: V) {
    if entity[keyPath: path] != value {
        logDebug("Data update for \(path), original: \(entity[keyPath: path]), new: \(value)", category: .coredata)
        entity[keyPath: path] = value
    }
}
