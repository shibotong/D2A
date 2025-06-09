//
//  NSManagedObject.swift
//  D2A
//
//  Created by Shibo Tong on 1/5/2025.
//

import CoreData

func setIfNotEqual<T: Any, V: Equatable>(entity: T, path: ReferenceWritableKeyPath<T, V>, value: V) {
    if entity[keyPath: path] != value {
        entity[keyPath: path] = value
    }
}
