//
//  Ability.swift
//  D2A
//
//  Created by Shibo Tong on 27/1/2026.
//

import CoreData

extension Ability {
    
    static func fetch(id: Int, context: NSManagedObjectContext) throws -> Ability? {
        let fetchRequest = Ability.fetchRequest()
        let predicate = NSPredicate(format: "abilityID = %d", id)
        fetchRequest.predicate = predicate
        return try context.fetch(fetchRequest).first
    }
    
    static func fetch(name: String, context: NSManagedObjectContext) throws -> Ability? {
        let fetchRequest = Ability.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = predicate
        return try context.fetch(fetchRequest).first
    }
    
    static func save(id: Int, name: String, data: [String: Any], in context: NSManagedObjectContext, syncingLogger: DataSyncingLogger? = nil) throws {
        let ability = try fetch(id: id, context: context) ?? Ability(context: context)
        setIfNotEqual(entity: ability, path: \.name, value: name)
        setIfNotEqual(entity: ability, path: \.abilityID, value: Int16(id))
        setStringOrArray(entity: ability, path: \.behavior, data: data, key: "behavior", syncingLogger: syncingLogger)
        setStringOrArray(entity: ability, path: \.bkbPierce, data: data, key: "behavior", syncingLogger: syncingLogger)
        setStringOrArray(entity: ability, path: \.coolDown, data: data, key: "cd", syncingLogger: syncingLogger)
        setStringOrArray(entity: ability, path: \.damageType, data: data, key: "dmg_type", syncingLogger: syncingLogger)
        setStringOrArray(entity: ability, path: \.damageType, data: data, key: "dmg_type", syncingLogger: syncingLogger)
        setIfExist(entity: ability, path: \.desc, data: data, key: "desc")
        setIfExist(entity: ability, path: \.dispellable, data: data, key: "dispellable")
        setIfExist(entity: ability, path: \.dname, data: data, key: "dname")
        setIfExist(entity: ability, path: \.lore, data: data, key: "lore")
        setStringOrArray(entity: ability, path: \.manaCost, data: data, key: "mc", syncingLogger: syncingLogger)
        setStringOrArray(entity: ability, path: \.targetTeam, data: data, key: "target_team", syncingLogger: syncingLogger)
        setStringOrArray(entity: ability, path: \.targetType, data: data, key: "target_type", syncingLogger: syncingLogger)
    }
    
    static func setStringOrArray(entity: Ability, path: ReferenceWritableKeyPath<Ability, String?>, data: [String: Any], key: String, syncingLogger: DataSyncingLogger? = nil) {
        guard let value = fetchStringOrArray(data: data, key: key, logger: syncingLogger) else {
            return
        }
        setIfNotEqual(entity: entity, path: path, value: value)
    }
        
    static func fetchStringOrArray(data: [String: Any], key: String, logger: DataSyncingLogger? = nil) -> String? {
        guard let value = data[key] else {
            return nil
        }
        
        if let result = value as? String {
            return result
        }
        
        if let array = value as? [String] {
            return array.joined(separator: " / ")
        }
        
        Task {
            await logger?.addError(type: .ability, error: .dataType, key: key)
        }
        
        return nil
    }
}
