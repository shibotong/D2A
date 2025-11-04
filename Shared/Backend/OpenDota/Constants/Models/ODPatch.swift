//
//  ODPatch.swift
//  D2A
//
//  Created by Shibo Tong on 25/9/2025.
//

import Foundation
import CoreData

struct ODPatch: Decodable, PersistanceModel {
    
    let name: String
    let id: Int
    let dateString: String
    
    enum CodingKeys: String, CodingKey {
        case name
        case id
        case dateString = "date"
    }
    
    var dictionaries: [String: Any] {
        return [
            "name": name,
            "patchID": Int16(id),
            "date": date
        ]
    }
    
    private var date: Date {
        let originalFormatter = ISO8601DateFormatter()
        let fractionFormatter = ISO8601DateFormatter()
        fractionFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        if let date = originalFormatter.date(from: dateString) {
            return date
        } else if let date = fractionFormatter.date(from: dateString) {
            return date
        } else {
            logError("Not able to parse date string: \(dateString)", category: .opendota)
            return Date()
        }
    }
    
    func update(context: NSManagedObjectContext) throws -> NSManagedObject {
        let predicate = NSPredicate(format: "patchID = %i", id)
        let patch = try context.fetchOne(type: Patch.self, predicate: predicate) ?? Patch(context: context)
        setIfNotEqual(entity: patch, path: \.patchID, value: Int16(id))
        setIfNotEqual(entity: patch, path: \.name, value: name)
        setIfNotEqual(entity: patch, path: \.date, value: date)
        return patch
    }
}
