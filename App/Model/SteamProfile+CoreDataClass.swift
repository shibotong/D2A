//
//  SteamProfile+CoreDataClass.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//
//

import Foundation
import CoreData

@objc(SteamProfile)
public class SteamProfile: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case profile
        case rank = "rank_tier"
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        guard let entity = NSEntityDescription.entity(forEntityName: "SteamProfile", in: context) else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }
        self.init(entity: entity, insertInto: context)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.profile = try container.decode(UserProfile.self, forKey: .profile)
        self.rank = try container.decode(Int16.self, forKey: .rank)
    }
}
