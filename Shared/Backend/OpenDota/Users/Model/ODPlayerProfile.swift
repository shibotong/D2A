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
        let lastLogin: String
        let country: String
        
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
