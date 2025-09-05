//
//  CoreDataMigrationManager.swift
//  D2A
//
//  Created by Shibo Tong on 6/9/2025.
//

import CoreData

struct CoreDataMigrationManager {
    func migration() {
        let manager = NSMigrationManager()
        manager.migrateStore(from: <#T##URL#>, type: .sqlite, options: <#T##[AnyHashable : Any]?#>, mapping: <#T##NSMappingModel#>, to: <#T##URL#>, type: <#T##NSPersistentStore.StoreType#>, options: <#T##[AnyHashable : Any]?#>)
        
    }
}
