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
        return try persistent(mapping: json, existing: existing)
    }
    
    func persistent<T: Mappable>(mapping json: [String: Any], existing: T?) throws -> T {
        let object = existing ?? T(context: self)
        try object.map(from: json)
        if object.hasChanges {
            try save()
        }
        return object
    }
    
    func hasData<T: NSManagedObject>(for entity: T.Type) -> Bool {
        let request = entity.fetchRequest()
        do {
            return try count(for: request) > 0
        } catch {
            logError("Failed to count \(entity)s: \(error)", category: .coredata)
            return true
        }
    }
    
    func batchInsert(dictionary: [[String: Any]], into entity: NSEntityDescription) {
        let insertRequest = NSBatchInsertRequest(entity: entity, objects: dictionary)
        insertRequest.resultType = .statusOnly
        do {
            let fetchResult = try execute(insertRequest)
            if let batchInsertResult = fetchResult as? NSBatchInsertResult,
               let success = batchInsertResult.result as? Bool {
                if !success {
                    logError("Failed to insert data in \(entity.name ?? "Unknown entity")", category: .coredata)
                } else {
                    logDebug("Insert data in \(entity.name ?? "Unknown entity") success", category: .coredata)
                }
            } else {
                logWarn("Cast NSBatchInsertResult failed", category: .coredata)
            }
        } catch {
            logError("An error occured in batch insert \(entity.name ?? "Unknown entity") \(error)", category: .coredata)
        }
    }
}
