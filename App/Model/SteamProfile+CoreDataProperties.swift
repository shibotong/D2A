//
//  SteamProfile+CoreDataProperties.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//
//

import Foundation
import CoreData


extension SteamProfile {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SteamProfile> {
        return NSFetchRequest<SteamProfile>(entityName: "SteamProfile")
    }

    @NSManaged public var rank: Int16
    @NSManaged public var profile: UserProfile?

}

extension SteamProfile : Identifiable {

}
