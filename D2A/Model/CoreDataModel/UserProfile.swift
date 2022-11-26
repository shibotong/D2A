//
//  UserProfile.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import Foundation
import CoreData

extension UserProfile {
    static func create(_ profile: UserProfileCodable) -> UserProfile {
        let viewContext = PersistenceController.shared.container.viewContext
        let newProfile = Self.fetch(id: profile.id) ?? UserProfile(context: viewContext)
        newProfile.id = Int32(profile.id)
        newProfile.avatarfull = profile.avatarfull
        
        newProfile.countryCode = profile.countryCode
        newProfile.personaname = profile.personaname
        newProfile.profileurl = profile.profileurl
        newProfile.isPlus = profile.isPlus ?? false
        if let rank = profile.rank {
            newProfile.rank = Int16(rank)
        }
        if let leaderboard = profile.leaderboard {
            newProfile.leaderboard = Int16(leaderboard)
        }
            
        newProfile.name = profile.name
        
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        print("save profile successfully \(newProfile.id)")
        return newProfile
    }
    
    static func make(_ profile: UserProfileCodable) -> UserProfile {
        let viewContext = PersistenceController.shared.container.viewContext
        let newProfile = UserProfile(context: viewContext)
        newProfile.id = Int32(profile.id)
        newProfile.avatarfull = profile.avatarfull
        
        newProfile.countryCode = profile.countryCode
        newProfile.personaname = profile.personaname
        newProfile.profileurl = profile.profileurl
        newProfile.isPlus = profile.isPlus ?? false
        if let rank = profile.rank {
            newProfile.rank = Int16(rank)
        }
        if let leaderboard = profile.leaderboard {
            newProfile.leaderboard = Int16(leaderboard)
        }
            
        newProfile.name = profile.name
        
        return newProfile
    }
    
    static func fetch(id: Int?) -> UserProfile? {
        guard let id = id else {
            return nil
        }
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchResult: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetchResult.predicate = NSPredicate(format: "id == %f", id)
        
        let results = try? viewContext.fetch(fetchResult)
        return results?.first
    }
    
    static func fetch(text: String) -> [UserProfile] {
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchResult: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetchResult.predicate = NSPredicate(format: "name CONTAINS[cd] %@", text)
        
        let results = try? viewContext.fetch(fetchResult)
        return results ?? []
    }
}
