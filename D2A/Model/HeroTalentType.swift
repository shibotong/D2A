//
//  HeroTalentType.swift
//  D2A
//
//  Created by Shibo Tong on 29/9/2022.
//

import Foundation

extension HeroTalentType {
    enum CoreDataError: Error {
        case nilValue
        case decodingError
    }
    
    static func createTalent(_ talent: HeroQuery.Data.Constant.Hero.Talent?) throws -> HeroTalentType {
        guard let talent = talent else {
            throw Self.CoreDataError.nilValue
        }
        let viewContext = PersistenceController.shared.container.viewContext
        let newTalent = HeroTalentType(context: viewContext)
        guard let talentID = talent.abilityId,
              let slot = talent.slot else {
            throw Self.CoreDataError.decodingError
        }
        newTalent.abilityId = talentID
        newTalent.slot = Int32(slot)
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return newTalent
    }
}
