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
