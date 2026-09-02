//
//  UserProfile.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import Foundation
import CoreData

extension UserProfile {
    
    /// If the profile should update. (Last update time is not today)
    var shouldUpdate: Bool {
        guard let lastUpdate else {
            return true
        }
        return !lastUpdate.isToday
    }
    
    static var canFavourite: Bool {
        return DotaEnvironment.shared.subscriptionStatus || favouriteUsersCount == 0
    }
    
    private static var favouriteUsersCount: Int {
        let viewContext = PersistenceProvider.shared.container.viewContext
        let fetchResult: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        var predicates: [NSPredicate] = []
        let favouritePredicate = NSPredicate(format: "favourite = %d", true)
        let registerPredicate = NSPredicate(format: "register = %d", false)
        predicates.append(favouritePredicate)
        predicates.append(registerPredicate)
        fetchResult.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        
        let results = try? viewContext.fetch(fetchResult)
        return results?.count ?? 0
    }
    
    /// Create a new `UserProfile` with favourite and register
    static func create(_ profile: UserProfileCodable, favourite: Bool, register: Bool) throws {
        let viewContext = PersistenceProvider.shared.makeContext(author: "UserProfile")
        let newProfile = fetch(id: profile.id.description, viewContext: viewContext) ?? UserProfile(context: viewContext)
        newProfile.map(profile)
        newProfile.favourite = favourite
        newProfile.register = register
        try viewContext.save()
        try viewContext.parent?.save()
    }
    
    static func create(_ profile: UserProfileCodable) throws -> UserProfile {
        let viewContext = PersistenceProvider.shared.makeContext(author: "UserProfile")
        let newProfile = fetch(id: profile.id.description, viewContext: viewContext) ?? UserProfile(context: viewContext)
        newProfile.map(profile)
        try viewContext.save()
        try viewContext.parent?.save()
        return newProfile
    }
    
    static func map(_ dto: UserProfileDTO, viewContext: NSManagedObjectContext) throws -> UserProfile {
        let newProfile = fetch(id: dto.id.description, viewContext: viewContext) ?? UserProfile(context: viewContext)
        newProfile.map(dto)
        try viewContext.save()
        return newProfile
    }
    
    func map(_ dto: UserProfileDTO) {
        setIfNotEqual(entity: self, path: \.id, value: dto.id.description)
        setIfNotEqual(entity: self, path: \.avatarfull, value: dto.avatarfull)
        
        setIfNotEqual(entity: self, path: \.countryCode, value: dto.countryCode)
        setIfNotEqual(entity: self, path: \.personaname, value: dto.personaname)
        setIfNotEqual(entity: self, path: \.profileurl, value: dto.profileurl)
        setIfNotEqual(entity: self, path: \.isPlus, value: dto.isPlus)
        setIfNotEqual(entity: self, path: \.rank, value: dto.rank as? NSNumber)
        setIfNotEqual(entity: self, path: \.leaderboard, value: dto.leaderboard as? NSNumber)
        setIfNotEqual(entity: self, path: \.name, value: dto.name)
        lastUpdate = Date()
    }
    
    /// Create a UserProfile object in CoreData for testing purpose
    static func create(id: String, favourite: Bool = false, register: Bool = false, controller: PersistenceProvider = PersistenceProvider.shared) {
        let viewContext = controller.makeContext(author: "UserProfile")
        let newProfile = UserProfile(context: viewContext)
        newProfile.id = id
        newProfile.name = "test name"
        newProfile.personaname = "test persona"
        newProfile.favourite = favourite
        newProfile.register = register
        newProfile.rank = 13
        newProfile.avatarfull = "nil"
        try? viewContext.save()
    }
    
    static func fetch(id: String, viewContext: NSManagedObjectContext = PersistenceProvider.shared.container.viewContext) -> UserProfile? {
        let fetchResult: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetchResult.predicate = NSPredicate(format: "id == %@", id)
        
        let results = try? viewContext.fetch(fetchResult)
        return results?.first
    }
    
    /// Search user saved in CoreData and marked as favourite
    static func fetch(text: String, favourite: Bool? = nil) -> [UserProfile] {
        let viewContext = PersistenceProvider.shared.container.viewContext
        let fetchResult: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        var predicates: [NSPredicate] = []
        let namePredicate = NSPredicate(format: "personaname CONTAINS[cd] %@", text)
        predicates.append(namePredicate)
        if let favourite {
            let favouritePredicate = NSPredicate(format: "favourite = %d", favourite)
            predicates.append(favouritePredicate)
        }
        fetchResult.predicate = NSCompoundPredicate(type: .and, subpredicates: predicates)
        
        let results = try? viewContext.fetch(fetchResult)
        return results ?? []
    }
    
    static func delete(id: String) {
        guard let user = fetch(id: id) else {
            return
        }
        let viewContext = PersistenceProvider.shared.container.viewContext
        viewContext.delete(user)
    }
    
    func update(favourite: Bool,
                viewContext: NSManagedObjectContext = PersistenceProvider.shared.container.viewContext) {
        self.favourite = favourite
        try? viewContext.save()
    }
    
    func update(register: Bool,
                viewContext: NSManagedObjectContext = PersistenceProvider.shared.container.viewContext) {
        self.register = register
        try? viewContext.save()
    }
}
