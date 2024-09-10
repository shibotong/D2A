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
    
    static func abilitiesInserted(viewContext: NSManagedObjectContext) -> Bool {
        let request = Ability.fetchRequest()
        let numberOfItems = (try? viewContext.count(for: request)) ?? 0
        return numberOfItems > 0
    }
    
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
                                 ability: ability,
                                 type: type,
                                 localisation: localisation)
        
        try context.save()
    }
    

    
    func updateValues(abilityID: Int,
                      abilityName: String,
                      ability: AbilityCodable,
                      type: AbilityType,
                      localisation: Localisation) {
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
        if let attributes = ability.attributes {
            let newAttributes = attributes.compactMap { AbilityAttribute(attribute: $0) }
            self.attributes = newAttributes
        }
//        self.attributes = ability.attributes?.compactMap { AbilityAttribute(attribute: $0) }
//        if let languageLocalisation = localisation.language,
//           let localisation = AbilityLocalisation(localisation: languageLocalisation, language: languageCode.rawValue, type: type) {
//            if localisations == nil {
//                localisations = [localisation]
//            } else {
//                localisations?.removeAll(where: { $0.language == languageCode.rawValue })
//                localisations?.append(localisation)
//            }
//        }
    }
    
    // Update localisation
    private func updateLocalisation(_ localisationData: Localisation,
                                    type: AbilityType) {
        if let localisation = localisations?.first(where: { $0.language == languageCode.rawValue }) {
            localisation.lore = localisationData.language?.lore
            localisation.displayName = localisationData.language?.displayName ?? ""
            
            switch type {
            case .scepter:
                localisation.scepter = localisationData.language?.aghanimDescription
                localisation.shard = nil
                localisation.abilityDescription = nil
            case .shared:
                localisation.shard = localisationData.language?.shardDescription
                localisation.scepter = nil
                localisation.abilityDescription = nil
            case .none:
                localisation.scepter = localisationData.language?.aghanimDescription
                localisation.shard = localisationData.language?.shardDescription
                localisation.abilityDescription = localisationData.language?.description?.compactMap{ $0 }.joined(separator: "\n")
            }
            Logger.shared.log(level: .verbose, message: "Update \(languageCode.rawValue) for \(abilityID)")
        } else {
            let localisation = AbilityLocalisation(language: languageCode.rawValue, displayName: localisationData.language?.displayName ?? "")
            localisation.lore = localisationData.language?.lore
            
            switch type {
            case .scepter:
                localisation.scepter = localisationData.language?.aghanimDescription
                localisation.shard = nil
                localisation.abilityDescription = nil
            case .shared:
                localisation.shard = localisationData.language?.shardDescription
                localisation.scepter = nil
                localisation.abilityDescription = nil
            case .none:
                localisation.scepter = localisationData.language?.aghanimDescription
                localisation.shard = localisationData.language?.shardDescription
                localisation.abilityDescription = localisationData.language?.description?.compactMap{ $0 }.joined(separator: "\n")
            }
            if localisations == nil {
                localisations = [localisation]
            } else {
                localisations?.append(localisation)
            }
            Logger.shared.log(level: .verbose, message: "Insert \(languageCode.rawValue) for \(abilityID)")
        }
    }
}
