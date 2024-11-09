//
//  CoreDataHelper.swift
//  D2A
//
//  Created by Shibo Tong on 9/11/2024.
//

import Foundation

func updateIfNotEqual<T: Any, V: Equatable>(entity: T, path: ReferenceWritableKeyPath<T, V>, value: V) {
    if entity[keyPath: path] != value {
        entity[keyPath: path] = value
    }
}
