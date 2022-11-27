//
//  Role.swift
//  D2A
//
//  Created by Shibo Tong on 29/9/2022.
//

import Foundation

extension Role {
    enum CoreDataError: Error {
        case nilValue
        case decodingError
    }
    
    static func createRole(_ role: HeroQuery.Data.Constant.Hero.Role?) throws -> Role {
        guard let role = role else {
            throw Self.CoreDataError.nilValue
        }
        let viewContext = PersistenceController.shared.container.viewContext
        let newRole = Role(context: viewContext)
        guard let roleID = role.roleId,
              let level = role.level else {
            throw Self.CoreDataError.decodingError
        }
        newRole.roleId = roleID.rawValue
        newRole.level = level
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return newRole
    }
}
