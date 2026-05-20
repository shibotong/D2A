//
//  MockOpenDotaFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 19/4/2026.
//

import Foundation
import OpenDota

public struct MockOpenDotaFetcher: OpenDotaFetching {
    
    private let fileReader: FileReader = .shared
    
    public init() {
        
    }
    
    public func constants(service: OpenDotaFetcher.ConstantService) async throws -> Any {
        let data = try fileReader.readFile(service.rawValue)
        return try JSONSerialization.jsonObject(with: data)
    }
}

public enum TestKitError: Error {
    case fileNotFound
}


