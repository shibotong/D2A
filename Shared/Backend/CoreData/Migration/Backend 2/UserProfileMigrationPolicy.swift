//
//  UserProfileMigrationPolicy.swift
//  D2A
//
//  Created by Shibo Tong on 6/9/2025.
//

import CoreData

class UserProfileMigrationPolicy: NSEntityMigrationPolicy {
    
    private let sourceKeyID = "id"
    private let destinationKeyID = "userID"
    
    override func begin(_ mapping: NSEntityMapping, with manager: NSMigrationManager) throws {
        logDebug("Start mapping UserProfile...", category: .coredata)
    }
    
    override func createDestinationInstances(forSource sInstance: NSManagedObject, in mapping: NSEntityMapping, manager: NSMigrationManager) throws {
        // Create the new destination object
        let dest = NSEntityDescription.insertNewObject(
            forEntityName: mapping.destinationEntityName!,
            into: manager.destinationContext
        )
        
        // Copy non-transformed attributes/relationships
        let keys = Array(sInstance.entity.attributesByName.keys)
        for key in keys {
            if key != sourceKeyID { // skip transformed field
                dest.setValue(sInstance.value(forKey: key), forKey: key)
            }
        }
        
        // Custom transformation
        if let sourceId = sInstance.value(forKey: sourceKeyID) as? String {
            let idInt = Int64(sourceId)
            dest.setValue(idInt, forKey: destinationKeyID)
        }

        // Set up the association
        manager.associate(sourceInstance: sInstance, withDestinationInstance: dest, for: mapping)
    }
}
