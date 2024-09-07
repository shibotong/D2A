//
//  Ability.swift
//  D2A
//
//  Created by Shibo Tong on 7/9/2024.
//

import Foundation
import CoreData
import StratzAPI

enum AbilityType {
    case scepter, shared, none
}

extension Ability {
    
    typealias Localisation = LocaliseQuery.Data.Constants.Ability
    
    /// Fetch `Ability` with `id` in `CoreData`
    static func fetchAbility(id: Int, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> Ability? {
        let viewContext = PersistenceController.shared.container.viewContext
        let request = Ability.fetchRequest()

        request.predicate = NSPredicate(format: "abilityID == %f", Double(id))
        request.fetchLimit = 1
        let results = try? viewContext.fetch(request)
        return results?.first
    }
    
    /// Fetch `Ability` with `name` in `CoreData`
    static func fetchAbility(name: String, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> Ability? {
        let viewContext = PersistenceController.shared.container.viewContext
        let request = Ability.fetchRequest()

        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1
        let results = try? viewContext.fetch(request)
        return results?.first
    }
    
    static func save(abilityID: Int,
                     abilityName: String,
                     ability: AbilityCodable,
                     localisation: Localisation,
                     type: AbilityType,
                     context: NSManagedObjectContext) throws {
        let abilityData = Ability.fetchAbility(id: abilityID) ?? Ability(context: context)
        
        abilityData.dname = ability.dname
//        abilityData.imageURL = nil
        abilityData.behaviour = ability.behavior?.transformString()
        abilityData.targetTeam = ability.targetTeam?.transformString()
        abilityData.targetType = ability.targetType?.transformString()
        abilityData.dmgType = ability.damageType?.transformString()
        abilityData.mc = ability.manaCost?.transformString()
        abilityData.cd = ability.coolDown?.transformString()
        abilityData.bkbPierce = ability.bkbPierce?.transformString()
        abilityData.dispellable = ability.dispellable?.transformString()
        
        // update attributes and localisation
        abilityData.updateAttributes(ability.attributes ?? [], context: context)
        abilityData.updateLocalisation(localisation, type: type, context: context)
        
        try context.save()
    }
    
    // Update localisation
    private func updateLocalisation(_ localisationData: Localisation,
                                    type: AbilityType,
                                    context: NSManagedObjectContext) {
        let localisation = fetchLocalisation(language: languageCode, context: context)
        localisation.descriptionAbility = localisationData.language?.displayName ?? ""
        localisation.lore = localisationData.language?.lore
        
        switch type {
        case .scepter:
            localisation.descriptionScepter = localisationData.language?.aghanimDescription
        case .shared:
            localisation.descriptionShard = localisationData.language?.shardDescription
        case .none:
            localisation.descriptionScepter = localisationData.language?.aghanimDescription
            localisation.descriptionShard = localisationData.language?.shardDescription
            localisation.descriptionAbility = localisationData.language?.description?.compactMap{ $0 }.joined(separator: "\n")
        }
    }
    
    private func updateAttributes(_ attributes: [AbilityCodableAttribute],
                                  context: NSManagedObjectContext) {
        self.attributes?.allObjects.forEach {
            guard let object = $0 as? NSManagedObject else {
                return
            }
            context.delete(object)
        }
        
        let attributes: [AbilityAttribute] = attributes.map {
            let attribute = AbilityAttribute(context: context)
            attribute.update($0)
            attribute.ability = self
            return attribute
        }
    }
    
    private func fetchLocalisation(language: Language, context: NSManagedObjectContext) -> AbilityLocalisation {
        guard let localisations = localisations?.allObjects as? [AbilityLocalisation],
              let savedLocalisation = localisations.first(where: { $0.language == language.rawValue }) else {
            let newLocalisation = AbilityLocalisation(context: context)
            newLocalisation.language = language.rawValue
            newLocalisation.ability = self
            return newLocalisation
        }
        
        return savedLocalisation
    }
}
