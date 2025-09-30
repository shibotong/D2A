//
//  League.swift
//  D2A
//
//  Created by Shibo Tong on 30/9/2025.
//

import CoreData

extension League: Mappable {
    static func predicate(id: Int) -> NSPredicate {
        return NSPredicate(format: "leagueID == %i", id)
    }
    
    enum CodingKeys: String, CodingKey {
        case leagueID = "league_id"
        case tier
        case name
    }
    
    func map(from json: [String: Any]) throws {
        guard let leagueID = json[CodingKeys.leagueID.rawValue] as? Int,
              let tier = json[CodingKeys.tier.rawValue] as? String,
              let name = json[CodingKeys.name.rawValue] as? String else {
            throw D2AError(message: "Failed to mapping league from JSON")
        }
        
        setIfNotEqual(entity: self, path: \.leagueID, value: Int32(leagueID))
        setIfNotEqual(entity: self, path: \.name, value: name)
        setIfNotEqual(entity: self, path: \.tier, value: tier)
    }
}
