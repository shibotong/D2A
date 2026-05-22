//
//  StringOrArray.swift
//  D2A
//
//  Created by Shibo Tong on 22/5/2026.
//

nonisolated
enum StringOrArray: Decodable, Sendable {
    case string(String)
    case array([String])
    
    init(from decoder: Decoder) throws {
        if let string = try? decoder.singleValueContainer().decode(String.self) {
            self = .string(string)
            return
        }
        
        if let array = try? decoder.singleValueContainer().decode([String].self) {
            self = .array(array)
            return
        }
        throw Error.couldNotFindStringOrArray
    }
    
    enum Error: Swift.Error {
        case couldNotFindStringOrArray
    }
    
    var arrayValue: [String] {
        switch self {
        case .string(let string):
            return [string]
        case .array(let array):
            if array.contains("Point Target") {
                return ["Point Target"]
            }
            if array.contains("Unit Target") {
                return ["Unit Target"]
            }
            if array.contains("No Target") {
                return ["No Target"]
            }
            return array
        }
    }
}
