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
    func fetchOne<T: NSManagedObject>(type: T.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]? = nil) throws -> T? {
        return try fetchAll(type: type, predicate: predicate, sortDescriptors: sortDescriptors, limit: 1).first
    }
    
    func fetchAll<T: NSManagedObject>(type: T.Type, predicate: NSPredicate, sortDescriptors: [NSSortDescriptor]? = nil, limit: Int? = nil) throws -> [T] {
        let fetchRequest = type.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.fetchLimit = 1
        fetchRequest.sortDescriptors = sortDescriptors
        return try fetch(fetchRequest) as? [T] ?? []
    }
}
