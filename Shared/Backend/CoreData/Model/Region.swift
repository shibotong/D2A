//
//  Region.swift
//  D2A
//
//  Created by Shibo Tong on 30/9/2025.
//

import CoreData
import SwiftUI

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
    
    var globeIcon: String {
        switch regionID {
        case 1, 2, 10, 14, 15, 38:
            return "globe.americas.fill"
        case 3, 8, 9, 11:
            return "globe.europe.africa.fill"
        case 5, 7, 12, 13, 17, 18, 19, 20, 25, 37:
            return "globe.asia.australia.fill"
        case 6, 16:
            return "globe.central.asia.fill"
        default:
            return "globe"
        }
    }
    
    var localizedName: LocalizedStringKey {
        LocalizedStringKey(name ?? "")
    }
}
