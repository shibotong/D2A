//
//  UserProfile.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import Foundation
import CoreData

extension UserProfile {
    static func create(_ profile: UserProfileCodable, favourite: Bool = false, register: Bool = false) throws -> UserProfile {
        let viewContext = PersistenceController.shared.makeContext()
        let newProfile = fetch(id: profile.id.description) ?? UserProfile(context: viewContext)
        newProfile.update(profile, favourite: favourite, register: register)
        try viewContext.save()
        return newProfile
    }
    
    static func fetch(id: String) -> UserProfile? {
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchResult: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetchResult.predicate = NSPredicate(format: "id == %@", id)
        
        let results = try? viewContext.fetch(fetchResult)
        return results?.first
    }
    
    static func fetch(text: String) -> [UserProfile] {
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchResult: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetchResult.predicate = NSPredicate(format: "personaname CONTAINS[cd] %@", text)
        
        let results = try? viewContext.fetch(fetchResult)
        return results ?? []
    }
    
    static func delete(id: String) {
        guard let user = fetch(id: id) else {
            return
        }
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(user)
    }
    
    func update(_ profile: UserProfileCodable, favourite: Bool, register: Bool) {
        id = profile.id.description
        avatarfull = profile.avatarfull
        
        countryCode = profile.countryCode
        personaname = profile.personaname
        profileurl = profile.profileurl
        isPlus = profile.isPlus ?? false
        if let rank = profile.rank {
            self.rank = Int16(rank)
        }
        if let leaderboard = profile.leaderboard {
            self.leaderboard = Int16(leaderboard)
        }
        
        self.favourite = favourite
        self.register = register
        name = profile.name
        lastUpdate = Date()
    }
}
