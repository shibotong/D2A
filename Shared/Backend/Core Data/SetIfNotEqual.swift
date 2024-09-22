//
//  SetIfNotEqual.swift
//  D2A
//
//  Created by Shibo Tong on 22/9/2024.
//

import Foundation

func setIfNotEqual<T: Any, V: Equatable>(entity: T, path: ReferenceWritableKeyPath<T, V>, value: V) {
    if entity[keyPath: path] != value {
        entity[keyPath: path] = value
    }
}
