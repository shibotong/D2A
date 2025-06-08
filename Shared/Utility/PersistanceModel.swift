//
//  D2ABatchInsertable.swift
//  D2A
//
//  Created by Shibo Tong on 2/5/2025.
//

import CoreData

protocol PersistanceModel {
    var dictionaries: [String: Any] { get }
    func update(context: NSManagedObjectContext) throws -> NSManagedObject
}
