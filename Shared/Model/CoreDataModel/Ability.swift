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
    static func fetchAbility(id: Int, viewContext: NSManagedObjectContext) -> Ability? {
        let request = Ability.fetchRequest()

        request.predicate = NSPredicate(format: "abilityID == %f", Double(id))
        request.fetchLimit = 1
        do {
            let results = try viewContext.fetch(request)
            return results.first
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /// Fetch `Ability` with `name` in `CoreData`
    static func fetchAbility(name: String, viewContext: NSManagedObjectContext = PersistenceController.shared.container.viewContext) -> Ability? {
        let request = Ability.fetchRequest()
        request.predicate = NSPredicate(format: "name == %@", name)
        request.fetchLimit = 1
        let results = try? viewContext.fetch(request)
        return results?.first
    }
    
    static func fetchAbilities(names: [String], viewContext: NSManagedObjectContext) -> [Ability] {
        let predicate = NSPredicate(format: "name IN %@", names)
        return runQuery(viewContext: viewContext, predicate: predicate)
    }
    
    static func runQuery(viewContext: NSManagedObjectContext,
                         predicate: NSPredicate? = nil) -> [Ability] {
        let fetchRequest = Ability.fetchRequest()
        fetchRequest.predicate = predicate
        do {
            let results = try viewContext.fetch(fetchRequest)
            return results
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    static func save(abilityID: Int,
                     abilityName: String,
                     ability: AbilityCodable,
                     localisation: Localisation,
                     type: AbilityType,
                     context: NSManagedObjectContext) throws {
        let abilityData = Ability.fetchAbility(id: abilityID, viewContext: context) ?? Ability(context: context)
        abilityData.updateValues(abilityID: abilityID,
                                 abilityName: abilityName,
                                 ability: ability)
        
        abilityData.updateLocalisation(localisation, type: type, context: context)
        
        try context.save()
    }
    
    func updateValues(abilityID: Int,
                      abilityName: String,
                      ability: AbilityCodable) {
        self.abilityID = Int32(abilityID)
        self.name = abilityName
        self.dname = ability.dname
        //        abilityData.imageURL = nil
        self.behaviour = ability.behavior?.transformString()
        self.targetTeam = ability.targetTeam?.transformString()
        self.targetType = ability.targetType?.transformString()
        self.dmgType = ability.damageType?.transformString()
        self.mc = ability.manaCost?.transformString()
        self.cd = ability.coolDown?.transformString()
        self.bkbPierce = ability.bkbPierce?.transformString()
        self.dispellable = ability.dispellable?.transformString()
        
        self.attributes = ability.attributes?.compactMap { AbilityAttribute(attribute: $0) }
    }
    
    // Update localisation
    private func updateLocalisation(_ localisationData: Localisation,
                                    type: AbilityType,
                                    context: NSManagedObjectContext) {
        let localisation = fetchLocalisation(language: languageCode, context: context)
        localisation.lore = localisationData.language?.lore
        localisation.displayName = localisationData.language?.displayName ?? ""
        
        switch type {
        case .scepter:
            localisation.descriptionScepter = localisationData.language?.aghanimDescription
            localisation.descriptionShard = nil
            localisation.descriptionAbility = nil
        case .shared:
            localisation.descriptionShard = localisationData.language?.shardDescription
            localisation.descriptionScepter = nil
            localisation.descriptionAbility = nil
        case .none:
            localisation.descriptionScepter = localisationData.language?.aghanimDescription
            localisation.descriptionShard = localisationData.language?.shardDescription
            localisation.descriptionAbility = localisationData.language?.description?.compactMap{ $0 }.joined(separator: "\n")
        }
    }
    
    private func updateAttributes(_ attributes: [AbilityCodableAttribute]) {
        
//        if let savedAttributes = self.attributes {
//            removeFromAttributes(savedAttributes)
//        }
//        
//        let attributes: [AbilityAttribute] = attributes.map {
//            let attribute = AbilityAttribute(context: context)
//            attribute.update($0)
//            attribute.ability = self
//            return attribute
//        }
//        
//        addToAttributes(NSSet(array: attributes))
    }
    
    private func fetchLocalisation(language: Language, context: NSManagedObjectContext) -> AbilityLocalisation {
        guard let localisations = localisations?.allObjects as? [AbilityLocalisation],
              let savedLocalisation = localisations.first(where: { $0.language == language.rawValue }) else {
            let newLocalisation = AbilityLocalisation(context: context)
            newLocalisation.language = language.rawValue
            addToLocalisations(newLocalisation)
            return newLocalisation
        }
        
        return savedLocalisation
    }
}
