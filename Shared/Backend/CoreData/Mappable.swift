//
//  Mappable.swift
//  D2A
//
//  Created by Shibo Tong on 11/12/2025.
//

import CoreData

protocol Mappable: NSManagedObject {
    func map(_ json: [String: Any])
}

extension Mappable {
    func setIfNotEqual<T: Equatable, V: NSManagedObject>(_ entity: V, keyPath: ReferenceWritableKeyPath<V, T>, value: T, logger: D2ALogger = .shared) {
        guard entity[keyPath: keyPath] != value else {
            return
        }
        logger.trace("update value for \(keyPath), original: \(entity[keyPath: keyPath]), newValue: \(value)", category: .coredata)
        entity[keyPath: keyPath] = value
    }
}
