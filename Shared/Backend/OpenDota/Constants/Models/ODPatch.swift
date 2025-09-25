//
//  ODPatch.swift
//  D2A
//
//  Created by Shibo Tong on 25/9/2025.
//

import Foundation

struct ODPatch: Decodable {
    let name: String
    let id: Int
    let date: String
    
    var dictionary: [String: Any] {
        let formatter = ISO8601DateFormatter()
        let date = {
            if let date = formatter.date(from: self.date) {
                return date
            } else {
                logError("Not able to parse date string: \(self.date)", category: .opendota)
                return Date()
            }
        }()
        
        return [
            "name": name,
            "patchID": Int16(id),
            "date": date
        ]
    }
}
