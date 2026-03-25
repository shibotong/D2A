//
//  AbilityTranslation.swift
//  D2A
//
//  Created by Shibo Tong on 25/3/2026.
//

import CoreData

extension AbilityTranslation {
    static func save(localization: SKAbility, language: DataLanguageEnum, in context: NSManagedObjectContext) throws {
        let translation = try fetch(id: localization.id, language: language, context: context) ?? AbilityTranslation(context: context)
        setIfNotEqual(entity: translation, path: \.language, value: language.rawValue)
        setIfNotEqual(entity: translation, path: \.abilityID, value: Int16(localization.id))
        setIfNotEqual(entity: translation, path: \.aghanimDescription, value: localization.aghanimDescription)
        setIfNotEqual(entity: translation, path: \.displayName, value: localization.displayName)
        setIfNotEqual(entity: translation, path: \.desc, value: localization.description.joined(separator: "\n"))
        setIfNotEqual(entity: translation, path: \.lore, value: localization.lore)
        setIfNotEqual(entity: translation, path: \.shardDescription, value: localization.shardDescription)
        setIfNotEqual(entity: translation, path: \.attributes, value: localization.attributes?.joined(separator: "\n"))
    }
    
    static func fetch(id: Int, language: DataLanguageEnum, context: NSManagedObjectContext) throws -> AbilityTranslation? {
        let fetchRequest = AbilityTranslation.fetchRequest()
        let predicate = NSPredicate(format: "abilityID = %d AND language = %@", id, language.rawValue)
        fetchRequest.predicate = predicate

        let results = try context.fetch(fetchRequest)
        return results.first
    }
}
