//
//  ODPlayerProfile.swift
//  D2A
//
//  Created by Shibo Tong on 18/8/21.
//

import Foundation
import CoreData

struct ODPlayerProfile: Decodable, PersistanceModel {
    
    let rank: Int?
    let leaderboard: Int?
    let profile: Profile

    enum CodingKeys: String, CodingKey {
        case profile
        case rank = "rank_tier"
        case leaderboard = "leaderboard_rank"
    }
    
    struct Profile: Decodable {
        let accountID: Int
        let personaname: String
        let name: String?
        let plus: Bool
        let cheese: Int
        let avatar: String
        let avatarMedium: String
        let avatarFull: String
        let profileURL: String
        let lastLogin: Date?
        let country: String?
        
        enum CodingKeys: String, CodingKey {
            case accountID = "account_id"
            case personaname
            case name
            case plus
            case cheese
            case avatar
            case avatarMedium = "avatarmedium"
            case avatarFull = "avatarfull"
            case profileURL = "profileurl"
            case lastLogin = "last_login"
            case country = "loccountrycode"
        }
        
        init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<ODPlayerProfile.Profile.CodingKeys> = try decoder.container(keyedBy: ODPlayerProfile.Profile.CodingKeys.self)
            self.accountID = try container.decode(Int.self, forKey: ODPlayerProfile.Profile.CodingKeys.accountID)
            self.personaname = try container.decode(String.self, forKey: ODPlayerProfile.Profile.CodingKeys.personaname)
            self.name = try container.decode(String.self, forKey: ODPlayerProfile.Profile.CodingKeys.name)
            self.plus = try container.decode(Bool.self, forKey: ODPlayerProfile.Profile.CodingKeys.plus)
            self.cheese = try container.decode(Int.self, forKey: ODPlayerProfile.Profile.CodingKeys.cheese)
            self.avatar = try container.decode(String.self, forKey: ODPlayerProfile.Profile.CodingKeys.avatar)
            self.avatarMedium = try container.decode(String.self, forKey: ODPlayerProfile.Profile.CodingKeys.avatarMedium)
            self.avatarFull = try container.decode(String.self, forKey: ODPlayerProfile.Profile.CodingKeys.avatarFull)
            self.profileURL = try container.decode(String.self, forKey: ODPlayerProfile.Profile.CodingKeys.profileURL)
            let lastLoginString = try container.decode(String.self, forKey: ODPlayerProfile.Profile.CodingKeys.lastLogin)
            self.country = try container.decode(String.self, forKey: ODPlayerProfile.Profile.CodingKeys.country)
            self.lastLogin = Date(utc: lastLoginString)
        }
        
        init?(json: [String: Any?]) {
            guard let accountID = json[CodingKeys.accountID.rawValue] as? Int,
            let personaname = json[CodingKeys.personaname.rawValue] as? String,
            let avatar = json[CodingKeys.avatar.rawValue] as? String,
            let avatarMedium = json[CodingKeys.avatarMedium.rawValue] as? String,
            let avatarFull = json[CodingKeys.avatarFull.rawValue] as? String,
            let profileURL = json[CodingKeys.profileURL.rawValue] as? String else {
                return nil
            }
            self.accountID = accountID
            self.personaname = personaname
            self.name = json[CodingKeys.name.rawValue] as? String
            self.plus = json[CodingKeys.plus.rawValue] as? Bool ?? false
            self.cheese = json[CodingKeys.cheese.rawValue] as? Int ?? 0
            self.avatar = avatar
            self.avatarMedium = avatarMedium
            self.avatarFull = avatarFull
            self.profileURL = profileURL
            self.country = json[CodingKeys.country.rawValue] as? String
            if let lastLogin = json[CodingKeys.lastLogin.rawValue] as? String {
                self.lastLogin = Date(utc: lastLogin)
            } else {
                self.lastLogin = nil
            }
        }
    }
    
    var dictionaries: [String : Any] {
        [:]
    }
    
    func update(context: NSManagedObjectContext) throws -> NSManagedObject {
        let user = UserProfile.fetch(id: "\(profile.accountID)", viewContext: context) ?? UserProfile(context: context)
        setIfNotEqual(entity: user, path: \.avatarfull, value: profile.avatarFull)
        setIfNotEqual(entity: user, path: \.countryCode, value: profile.country)
        setIfNotEqual(entity: user, path: \.id, value: "\(profile.accountID)")
        setIfNotEqual(entity: user, path: \.isPlus, value: profile.plus)
        setIfNotEqual(entity: user, path: \.lastUpdate, value: Date())
        setIfNotEqual(entity: user, path: \.leaderboard, value: Int16(leaderboard ?? 0))
        setIfNotEqual(entity: user, path: \.name, value: profile.name)
        setIfNotEqual(entity: user, path: \.personaname, value: profile.personaname)
        setIfNotEqual(entity: user, path: \.profileurl, value: profile.profileURL)
        setIfNotEqual(entity: user, path: \.rank, value: Int16(rank ?? 0))
        return user
    }
    
    func update(context: NSManagedObjectContext, favourite: Bool, register: Bool) throws {
        let user = try update(context: context) as! UserProfile
        setIfNotEqual(entity: user, path: \.favourite, value: favourite)
        setIfNotEqual(entity: user, path: \.register, value: register)
    }
}
