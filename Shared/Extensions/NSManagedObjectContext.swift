//
//  NSManagedObjectContext.swift
//  D2A
//
//  Created by Shibo Tong on 27/1/2026.
//

import CoreData

extension NSManagedObjectContext {
    func makeContext(author: String? = nil) -> NSManagedObjectContext {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.parent = self
        privateContext.transactionAuthor = author
        privateContext.automaticallyMergesChangesFromParent = true
        return privateContext
    }
}
