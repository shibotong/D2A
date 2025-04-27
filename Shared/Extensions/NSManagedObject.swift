//
//  NSManagedObject.swift
//  D2A
//
//  Created by Shibo Tong on 27/4/2025.
//

import Foundation
import CoreData

func setIfNotEqual<T: Any, V: Equatable>(entity: T, path: ReferenceWritableKeyPath<T, V>, value: V) {
    if entity[keyPath: path] != value {
        entity[keyPath: path] = value
    }
}
