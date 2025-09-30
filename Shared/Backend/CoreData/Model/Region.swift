//
//  Region.swift
//  D2A
//
//  Created by Shibo Tong on 30/9/2025.
//

import CoreData

extension Region: Mappable {
    static func predicate(id: Int) -> NSPredicate {
        NSPredicate(format: "regionID == %i", id)
    }
    
    enum CodingKeys: String {
        case id
        case name
    }
    
    func map(from json: [String: Any]) throws {
        guard let regionID = json[CodingKeys.id.rawValue] as? Int,
              let name = json[CodingKeys.name.rawValue] as? String else {
            throw D2AError(message: "Failed to mapping Region")
        }
        
        setIfNotEqual(entity: self, path: \.regionID, value: Int16(regionID))
        setIfNotEqual(entity: self, path: \.name, value: name)
    }
}
