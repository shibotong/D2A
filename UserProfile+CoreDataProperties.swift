//
//  UserProfile+CoreDataProperties.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//
//

import Foundation
import CoreData


extension UserProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
        return NSFetchRequest<UserProfile>(entityName: "UserProfile")
    }

    @NSManaged public var id: Int64
    @NSManaged public var avatarfull: String?
    @NSManaged public var lastLogin: String?
    @NSManaged public var countryCode: String?
    @NSManaged public var personaname: String?
    @NSManaged public var isPlus: Bool
    @NSManaged public var profileurl: String?
    @NSManaged public var steamProfile: SteamProfile?

}

extension UserProfile : Identifiable {

}
