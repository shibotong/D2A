//
//  MockOpenDotaFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 19/4/2026.
//

import Foundation
import OpenDota
import StaticDataKit

public struct MockOpenDotaFetcher: OpenDotaFetching {
    
    public init() {
        
    }
    
    public func constants(service: OpenDotaFetcher.ConstantService) async throws -> Any {
        let data = try readFile(service.rawValue)
        return try JSONSerialization.jsonObject(with: data)
    }
}
