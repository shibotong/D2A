//
//  Talent.swift
//  D2A
//
//  Created by Shibo Tong on 29/9/2022.
//

import Foundation
import StratzAPI

extension Talent {
    enum CoreDataError: Error {
        case nilValue
        case decodingError
    }
    
    static func createTalent(_ talent: HeroQuery.Data.Constants.Hero.Talent?) throws -> Talent {
        guard let talent = talent else {
            throw CoreDataError.nilValue
        }
        let viewContext = PersistanceProvider.shared.container.viewContext
        let newTalent = Talent(context: viewContext)
        guard let talentID = talent.abilityId,
              let slot = talent.slot else {
            throw CoreDataError.decodingError
        }
        newTalent.abilityId = talentID
        newTalent.slot = Int32(slot)
        try viewContext.save()
        return newTalent
    }
}
