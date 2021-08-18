//
//  UserProfile+CoreDataClass.swift
//  App
//
//  Created by Shibo Tong on 18/8/21.
//
//

import Foundation
import CoreData

@objc(UserProfile)
public class UserProfile: NSManagedObject, Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "account_id"
        case avatarfull
        case lastLogin = "last_login"
        case countryCode = "loccountrycode"
        case personaname
        case isPlus = "plus"
        case profileurl
    }
    
    required convenience public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
              throw DecoderConfigurationError.missingManagedObjectContext
            }
        guard let entity = NSEntityDescription.entity(forEntityName: "UserProfile", in: context) else {
            throw DecoderConfigurationError.missingManagedObjectContext
        }

        self.init(entity: entity, insertInto: context)

            let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(Int64.self, forKey: .id)
        self.avatarfull = try container.decode(String.self, forKey: .avatarfull)
        self.lastLogin = try container.decode(String?.self, forKey: .lastLogin)
        self.countryCode = try container.decode(String?.self, forKey: .countryCode)
        self.personaname = try container.decode(String.self, forKey: .personaname)
        self.isPlus = try container.decode(Bool.self, forKey: .isPlus)
        self.profileurl = try container.decode(String.self, forKey: .profileurl)
    }
}
