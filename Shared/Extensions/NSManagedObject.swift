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

extension NSManagedObjectContext {
    func fetchOne<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil) throws -> T? {
        return try fetchAll(type: type, predicate: predicate, sortDescriptors: sortDescriptors, limit: 1).first
    }
    
    func fetchAll<T: NSManagedObject>(type: T.Type, predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, limit: Int? = nil) throws -> [T] {
        let fetchRequest = type.fetchRequest()
        fetchRequest.predicate = predicate
        if let limit {
            fetchRequest.fetchLimit = limit
        }
        fetchRequest.sortDescriptors = sortDescriptors
        return try fetch(fetchRequest) as? [T] ?? []
    }
    
    func saveChanges() throws {
        try save()
        try parent?.saveChanges()
    }
    
    func persistent<T: Mappable>(mapping json: [String: Any], to type: T.Type, id: Int) throws -> T {
        let existing = try fetchOne(type: T.self, predicate: T.predicate(id: id))
        let object = existing ?? T(context: self)
        try object.map(from: json)
        try save()
        return object
    }
}
