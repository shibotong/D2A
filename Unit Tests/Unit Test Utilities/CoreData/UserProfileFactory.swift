//
//  UserProfileFactory.swift
//  D2A
//
//  Created by Shibo Tong on 13/10/2026.
//

import CoreData
@testable import D2A

extension UserProfile {
    static func make(context: NSManagedObjectContext) -> UserProfile {
        let user = UserProfile(context: context)
            .with(path: \.id, value: "random-user-id")
            .with(path: \.personaname, value: "random-persona-name")
            .with(path: \.avatarfull, value: "https://example.com")
        return user
    }
    
    func with<T>(path: WritableKeyPath<UserProfile, T>, value: T) -> UserProfile {
        var user = self
        user[keyPath: path] = value
        return user
    }
}
