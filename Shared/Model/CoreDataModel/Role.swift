//
//  Role.swift
//  D2A
//
//  Created by Shibo Tong on 29/9/2022.
//

import Foundation
import StratzAPI

extension Role {
    enum CoreDataError: Error {
        case nilValue
        case decodingError
    }
    
    static func createRole(_ role: HeroQuery.Data.Constants.Hero.Role?) throws -> Role {
        guard let role = role else {
            throw CoreDataError.nilValue
        }
        let viewContext = PersistanceController.shared.container.viewContext
        let newRole = Role(context: viewContext)
        guard let roleID = role.roleId,
              let level = role.level else {
            throw CoreDataError.decodingError
        }
        newRole.roleId = roleID.rawValue
        newRole.level = level
        try viewContext.save()
        return newRole
    }
}
