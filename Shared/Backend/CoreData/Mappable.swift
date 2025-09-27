//
//  Mappable.swift
//  D2A
//
//  Created by Shibo Tong on 26/9/2025.
//

import CoreData

protocol Mappable: NSManagedObject {
    func map(from: [String: Any]) throws
}
