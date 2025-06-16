//
//  ODGameMode.swift
//  D2A
//
//  Created by Shibo Tong on 9/6/2025.
//

import Foundation
import CoreData

struct ODGameMode: Decodable, PersistanceModel {
    
    var id: Int
    var name: String
    var balanced: Bool
    
    var dictionaries: [String : Any] {
        return [
            "id": id,
            "name": name,
            "balanced": balanced
        ]
    }
    
    func update(context: NSManagedObjectContext) throws -> NSManagedObject {
        let mode = try GameMode.fetch(id: id, context: context) ?? GameMode(context: context)
        
        setIfNotEqual(entity: mode, path: \.id, value: Int16(id))
        setIfNotEqual(entity: mode, path: \.name, value: name)
        setIfNotEqual(entity: mode, path: \.balanced, value: balanced)

        return mode
    }
}
