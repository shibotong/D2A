//
//  UserProfile.swift
//  D2A
//
//  Created by Shibo Tong on 26/11/2022.
//

import Foundation
import CoreData
import UIKit

extension UserProfile {
    static func create(_ profile: UserProfileCodable) async -> UserProfile? {
        let viewContext = PersistenceController.shared.container.viewContext
        let newProfile = Self.fetch(id: profile.id) ?? UserProfile(context: viewContext)
        do {
            try await newProfile.update(profile)
        } catch {
            print(error)
            return nil
        }
        print("save user success \(newProfile.personaname)")
        return newProfile
    }
    
    static func fetch(id: Int?) -> UserProfile? {
        guard let id = id else {
            return nil
        }
        let viewContext = PersistenceController.shared.container.viewContext
        let fetchResult: NSFetchRequest<UserProfile> = UserProfile.fetchRequest()
        fetchResult.predicate = NSPredicate(format: "id == %d", id)
        
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
    
    static func delete(id: Int?) {
        guard let user = Self.fetch(id: id) else {
            return
        }
        let viewContext = PersistenceController.shared.container.viewContext
        viewContext.delete(user)
    }
    
    func update(_ profile: UserProfileCodable) async throws {
        let viewContext = PersistenceController.shared.container.viewContext
        try await viewContext.perform {
            self.id = Int32(profile.id)
            self.avatarfull = profile.avatarfull
            
            self.countryCode = profile.countryCode
            self.personaname = profile.personaname
            self.profileurl = profile.profileurl
            self.isPlus = profile.isPlus ?? false
            if let rank = profile.rank {
                self.rank = Int16(rank)
            }
            if let leaderboard = profile.leaderboard {
                self.leaderboard = Int16(leaderboard)
            }
            
            self.name = profile.name
            
            try viewContext.save()
        }
    }
}
