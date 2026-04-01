//
//  HeroTranslation.swift
//  D2A
//
//  Created by Shibo Tong on 1/4/2026.
//

import CoreData

extension HeroTranslation {
    static func save(localization: SKHero, language: DataLanguageEnum, in context: NSManagedObjectContext) throws {
        let translation = try fetch(id: localization.id, language: language, context: context) ?? HeroTranslation(context: context)
        setIfNotEqual(entity: translation, path: \.language, value: language.rawValue)
        setIfNotEqual(entity: translation, path: \.heroID, value: Int16(localization.id))
        setIfNotEqual(entity: translation, path: \.displayName, value: localization.displayName)
        setIfNotEqual(entity: translation, path: \.lore, value: localization.lore)
        setIfNotEqual(entity: translation, path: \.hype, value: localization.hype)
    }
    
    static func fetch(id: Int, language: DataLanguageEnum, context: NSManagedObjectContext) throws -> HeroTranslation? {
        let fetchRequest = HeroTranslation.fetchRequest()
        let predicate = NSPredicate(format: "heroID = %d AND language = %@", id, language.rawValue)
        fetchRequest.predicate = predicate

        let results = try context.fetch(fetchRequest)
        return results.first
    }
}
