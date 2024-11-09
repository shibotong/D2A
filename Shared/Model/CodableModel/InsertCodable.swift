//
//  InsertCodable.swift
//  D2A
//
//  Created by Mac mini Server on 9/11/2024.
//

import Foundation

protocol InsertCodable {
    var batchInsertDictionary: [String: Any] { get }
}

protocol InsertCoreData {
    func update(modelData: InsertCoreData)
}
