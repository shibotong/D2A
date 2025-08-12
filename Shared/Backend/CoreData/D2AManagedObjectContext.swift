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
