//
//  CoreDataMigrationManager.swift
//  D2A
//
//  Created by Shibo Tong on 6/9/2025.
//

import CoreData

struct CoreDataMigrationManager {
    func migration() throws {
        guard let sourceModelURL = Bundle.main.url(forResource: "Backend", withExtension: "xcdatamodel"),
              let destinationModelURL = Bundle.main.url(forResource: "Backend 2", withExtension: "xcdatamodel"),
        let mappingModelURL = Bundle.main.url(forResource: "Version2Mapping", withExtension: "xcmappingmodel") else {
            throw D2AError(message: "Not able to find source model or destination model")
        }
        
        let manager = NSMigrationManager()
        
        
    }
}
