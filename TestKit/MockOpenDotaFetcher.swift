//
//  MockOpenDotaFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 19/4/2026.
//

import Foundation
import OpenDota
import StaticDataKit

nonisolated
public struct MockOpenDotaFetcher: OpenDotaFetching {
    
    public init() {
        
    }
    
    public func constants(service: OpenDotaFetcher.ConstantService) async throws -> Any {
        let data = try readFile(service.rawValue)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    func readFile(_ name: String) throws -> Data {
        guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
            throw TestKitError.fileNotFound
        }
        return try Data(contentsOf: URL(fileURLWithPath: path))
    }
}

public enum TestKitError: Error {
    case fileNotFound
}


