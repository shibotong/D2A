//
//  MockOpenDotaFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 19/4/2026.
//

import OpenDota
import Foundation

public struct MockOpenDotaFetcher: OpenDotaFetching {
    
    public init() {
        
    }
    
    public func constants(service: OpenDotaFetcher.ConstantService) async throws -> Any {
        switch service {
        case .abilities:
            guard let data = try readFile("abilities") else {
                throw TestError.fileNotExist
            }
            return try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        case .abilityIDs:
            guard let data = try readFile("ability_ids") else {
                throw TestError.fileNotExist
            }
            return try! JSONSerialization.jsonObject(with: data) as! [String: String]
        case .heroes:
            guard let data = try readFile("heroes") else {
                throw TestError.fileNotExist
            }
            return try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        case .heroAbilities:
            guard let data = try readFile("hero_abilities") else {
                throw TestError.fileNotExist
            }
            return try! JSONSerialization.jsonObject(with: data) as! [String: Any]
        default:
            return "service not provided"
        }
    }
}

public enum TestError: Error {
    case fileNotExist
}
