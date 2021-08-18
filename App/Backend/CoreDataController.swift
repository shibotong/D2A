//
//  CoreDataController.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation
import CoreData

class CoreDataController {
    static var shared = CoreDataController()
    var container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "Backend")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Unable to load persistent stores: \(error)")
            }
        }
    }
    
    func saveContext(backgroundContext: NSManagedObjectContext? = nil) {
        let viewContext = container.viewContext
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
