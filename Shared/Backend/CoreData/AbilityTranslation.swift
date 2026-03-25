//
//  AbilityTranslation.swift
//  D2A
//
//  Created by Shibo Tong on 25/3/2026.
//

import CoreData
import StratzAPI

extension AbilityTranslation {
    static func save(localization: SKAbility, language: DataLanguageEnum, in context: NSManagedObjectContext) throws {
        let translation = try fetch(id: localization.id, language: language, context: context) ?? AbilityTranslation(context: context)
        setIfNotEqual(entity: translation, path: \.language, value: language.rawValue)
        setIfNotEqual(entity: translation, path: \.abilityID, value: Int16(localization.id))
        setIfNotEqual(entity: translation, path: \.name, value: localization.name)
        setIfNotEqual(entity: translation, path: \.aghanimDescription, value: localization.aghanimDescription)
        setIfNotEqual(entity: translation, path: \.displayName, value: localization.displayName)
        setIfNotEqual(entity: translation, path: \.desc, value: localization.description.joined(separator: "\n"))
        setIfNotEqual(entity: translation, path: \.lore, value: localization.lore)
        setIfNotEqual(entity: translation, path: \.shardDescription, value: localization.shardDescription)
        setIfNotEqual(entity: translation, path: \.attributes, value: localization.attributes?.compactMap({ $0 }))
    }
    
    static func fetch(id: Int, language: DataLanguageEnum, context: NSManagedObjectContext) throws -> AbilityTranslation? {
        let fetchRequest = AbilityTranslation.fetchRequest()
        let predicate = NSPredicate(format: "abilityID = %d AND language = %@", id, language.rawValue)
        fetchRequest.predicate = predicate

        let results = try context.fetch(fetchRequest)
        return results.first
    }
    
    static func fetch(name: String, language: DataLanguageEnum, context: NSManagedObjectContext) throws -> AbilityTranslation? {
        let fetchRequest = AbilityTranslation.fetchRequest()
        let predicate = NSPredicate(format: "name = %@ AND language = %@", name, language.rawValue)
        fetchRequest.predicate = predicate

        let results = try context.fetch(fetchRequest)
        return results.first
    }
    
    var localizedAttributes: [StratzAttribute]? {
        guard let localizedString = attributes else {
            return nil
        }
        var localizedAttributes: [StratzAttribute] = []
        for item in localizedString {
            let splits = item.split(separator: colonLocalize)
            if splits.count == 2 {
                let header = String(splits.first ?? "")
                var message = String(splits.last ?? "")
                if let abilityName = name,
                   let attributes,
                   message.first == "%" && message.last == "%" {
                    let key = extractAttributeKey(input: message, abilityName: abilityName)
                    message = attributes.filter({ attribute in
                        return attribute == key
                    }).first ?? message
                }
                localizedAttributes.append(StratzAttribute(name: header, description: message))
            } else {
                localizedAttributes.append(StratzAttribute(name: item, description: ""))
            }
        }
        return localizedAttributes
    }
    
    private func extractAttributeKey(input: String, abilityName: String) -> String {
        let pattern = "%DOTA_Tooltip_Ability_\(abilityName)_(\\w+)%"
        do {
            // Create a regular expression object with the defined pattern
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            
            // Find the first match in the input string
            if let match = regex.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.utf16.count)) {
                // Extract the substring using the captured group
                let range = Range(match.range(at: 1), in: input)!
                return String(input[range])
            }
            return input
        } catch {
            print("Error creating regular expression: \(error)")
            return input
        }
    }
}
