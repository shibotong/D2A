//
//  OpenDotaConstantFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 22/6/2025.
//

import Foundation

protocol OpenDotaConstantFetching {
    func loadService<T: Decodable>(service: OpenDotaConstantService, as type: T.Type) async throws -> T?
}

class OpenDotaConstantFetcher: OpenDotaConstantFetching {
    
    private let network = D2ANetwork.default
    
    func loadService<T: Decodable>(service: OpenDotaConstantService, as type: T.Type) async throws -> T? {
        let url = service.serviceURL
        let data = try await network.dataTask(url, as: T.self)
        return data
    }
}

