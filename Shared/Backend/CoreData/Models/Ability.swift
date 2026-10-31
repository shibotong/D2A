//
//  Ability.swift
//  D2A
//
//  Created by Shibo Tong on 23/4/2026.
//

import CoreData

extension Ability {
    
    nonisolated
    static func fetch(abilityID: Int, context: NSManagedObjectContext) throws -> Ability? {
        let fetchRequest = NSFetchRequest<Ability>(entityName: "Ability")
        let predicate = NSPredicate(format: "abilityID = %d", abilityID)
        fetchRequest.predicate = predicate
        return try context.fetch(fetchRequest).first
    }
    
    nonisolated
    static func fetch(name: String, context: NSManagedObjectContext) throws -> Ability? {
        let fetchRequest = NSFetchRequest<Ability>(entityName: "Ability")
        let predicate = NSPredicate(format: "name = %@", name)
        fetchRequest.predicate = predicate
        return try context.fetch(fetchRequest).first
    }
    
    var displayName: String {
        return localization?.displayName ?? dname ?? ""
    }
    
    var localization: AbilityTranslation? {
        return fetchLocalization()
    }
    
    var scepter: String? {
        return localization?.aghanimDescription
    }
    
    var shard: String? {
        return localization?.shardDescription
    }
    
    var localizedAttributes: [AbilityTranslation.Attribute] {
        return localization?.localizedAttributes ?? []
    }
    
    var localizedDescription: String? {
        return localization?.desc
    }
    
    var localizedLore: String? {
        return localization?.lore
    }
    
    func fetchLocalization(language: DataLanguageEnum = AppConfig.shared.languageCode) -> AbilityTranslation? {
        guard let abilityLocalizations = localizations?.allObjects as? [AbilityTranslation] else {
            return nil
        }
        return abilityLocalizations.first(where: { $0.language == language.rawValue })
    }
    
    nonisolated func map(dto: any AbilityDTO) {
        setIfNotEqual(entity: self, path: \.name, value: dto.name)
        setIfNotEqual(entity: self, path: \.abilityID, value: Int16(dto.abilityID))
        setIfNotEqual(entity: self, path: \.behavior, value: dto.behavior?.joined(separator: " / "))
        setIfNotEqual(entity: self, path: \.bkbPierce, value: dto.bkbpierce?.joined(separator: " / "))
        setIfNotEqual(entity: self, path: \.coolDown, value: dto.cd?.joined(separator: " / "))
        setIfNotEqual(entity: self, path: \.damageType, value: dto.dmgType?.joined(separator: " / "))
        setIfNotEqual(entity: self, path: \.desc, value: dto.desc)
        setIfNotEqual(entity: self, path: \.dispellable, value: dto.dispellable)
        setIfNotEqual(entity: self, path: \.dname, value: dto.dname)
        setIfNotEqual(entity: self, path: \.lore, value: dto.lore)
        setIfNotEqual(entity: self, path: \.manaCost, value: dto.mc?.joined(separator: " / "))
        setIfNotEqual(entity: self, path: \.targetTeam, value: dto.targetTeam?.joined(separator: " / "))
        setIfNotEqual(entity: self, path: \.targetType, value: dto.targetType?.joined(separator: " / "))
        if let img = dto.img {
            setIfNotEqual(entity: self, path: \.img, value: img)
        }
    }
}
