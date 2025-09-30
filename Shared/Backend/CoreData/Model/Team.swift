//
//  Team.swift
//  D2A
//
//  Created by Shibo Tong on 30/9/2025.
//

import CoreData

extension Team: Mappable {
    static func predicate(id: Int) -> NSPredicate {
        return NSPredicate(format: "teamID == %i", id)
    }
    
    enum CodingKeys: String, CodingKey {
        case teamID = "team_id"
        case name
        case tag
        case logoURL = "logo_url"
    }
    
    func map(from json: [String: Any]) throws {
        guard let teamID = json[CodingKeys.teamID.rawValue] as? Int,
              let name = json[CodingKeys.name.rawValue] as? String,
              let tag = json[CodingKeys.tag.rawValue] as? String,
              let logoURL = json[CodingKeys.logoURL.rawValue] as? String else {
            throw D2AError(message: "Failed to mapping team from JSON")
        }
        
        setIfNotEqual(entity: self, path: \.teamID, value: Int32(teamID))
        setIfNotEqual(entity: self, path: \.name, value: name)
        setIfNotEqual(entity: self, path: \.tag, value: tag)
        setIfNotEqual(entity: self, path: \.imageURL, value: logoURL)
    }
}
