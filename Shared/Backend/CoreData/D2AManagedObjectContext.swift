//
//  D2AManagedObjectContext.swift
//  D2A
//
//  Created by Shibo Tong on 12/8/2025.
//

import CoreData

class D2AManagedObjectContext: NSManagedObjectContext {
    override func save() throws {
        try super.save()
        try parent?.save()
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
    
    /// Check if there is any data saved in core data
    func hasData<T: NSManagedObject>(for entity: T.Type) -> Bool {
        let request = entity.fetchRequest()
        request.fetchLimit = 1
        do {
            let count = try count(for: request)
            return count > 0
        } catch {
            logError("Cannot count number of \(entity) saved in Core Data", category: .coredata)
            return true
        }
    }
}
