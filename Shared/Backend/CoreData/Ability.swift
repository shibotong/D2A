//
//  Ability.swift
//  D2A
//
//  Created by Shibo Tong on 27/1/2026.
//

import CoreData

extension Ability {
    
    static func save(id: Int, name: String, data: [String: Any], localization: SKAbility?, in context: NSManagedObjectContext) throws {
        let fetchRequest = Ability.fetchRequest()
        let predicate = NSPredicate(format: "abilityID = %d", id)
        fetchRequest.predicate = predicate
        let ability = try context.fetch(fetchRequest).first ?? Ability(context: context)
        setIfNotEqual(entity: ability, path: \.name, value: name)
        setIfNotEqual(entity: ability, path: \.abilityID, value: Int16(id))
        setStringOrArray(entity: ability, path: \.behavior, data: data, key: "behavior")
        setStringOrArray(entity: ability, path: \.bkbPierce, data: data, key: "behavior")
        setStringOrArray(entity: ability, path: \.coolDown, data: data, key: "cd")
        setStringOrArray(entity: ability, path: \.damageType, data: data, key: "dmg_type")
        setStringOrArray(entity: ability, path: \.damageType, data: data, key: "dmg_type")
        setIfExist(entity: ability, path: \.desc, data: data, key: "desc", localization: localization?.description.joined(separator: "\n"))
        setIfExist(entity: ability, path: \.dispellable, data: data, key: "dispellable")
        setIfExist(entity: ability, path: \.dname, data: data, key: "dname", localization: localization?.displayName)
        setIfExist(entity: ability, path: \.lore, data: data, key: "lore", localization: localization?.lore)
        setStringOrArray(entity: ability, path: \.manaCost, data: data, key: "mc")
        setStringOrArray(entity: ability, path: \.targetTeam, data: data, key: "target_team")
        setStringOrArray(entity: ability, path: \.targetType, data: data, key: "target_type")
    }
    
    static func setStringOrArray(entity: Ability, path: ReferenceWritableKeyPath<Ability, String?>, data: [String: Any], key: String) {
        guard let value = fetchStringOrArray(data: data, key: key) else {
            return
        }
        setIfNotEqual(entity: entity, path: path, value: value)
    }
        
    static func fetchStringOrArray(data: [String: Any], key: String) -> String? {
        if let result = data[key] as? String {
            return result
        }
        
        if let array = data[key] as? [String] {
            return array.joined(separator: " / ")
        }
        
        return nil
    }
}
