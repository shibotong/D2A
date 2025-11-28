//
//  NSManagedObject.swift
//  D2A
//
//  Created by Shibo Tong on 28/11/2025.
//

func setIfNotEqual<T: Any, V: Equatable>(entity: T, path: ReferenceWritableKeyPath<T, V>, value: V) {
    if entity[keyPath: path] != value {
        logger.debug("Data update for \(path), original: \(entity[keyPath: path]), new: \(value)")
        entity[keyPath: path] = value
    }
}
