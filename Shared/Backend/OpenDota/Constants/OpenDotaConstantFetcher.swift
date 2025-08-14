//
//  OpenDotaConstantFetcher.swift
//  D2A
//
//  Created by Shibo Tong on 22/6/2025.
//

import Foundation

protocol OpenDotaConstantFetching {
    func loadService<T: Decodable>(service: OpenDotaConstantService, as type: T.Type) async -> T?
}

class OpenDotaConstantFetcher: OpenDotaConstantFetching {
    
    private let network = D2ANetwork.default
    
    func loadService<T: Decodable>(service: OpenDotaConstantService, as type: T.Type) async -> T? {
        let url = service.serviceURL
        do {
            let data = try await network.dataTask(url, as: T.self)
            return data
        } catch {
            logWarn("Loading \(service) from OpenDota failed: \(error)", category: .opendotaConstant)
            return nil
        }
    }
}

class LocalOpenDotaConstantFetcher: OpenDotaConstantFetching {
    func loadService<T: Decodable>(service: OpenDotaConstantService, as type: T.Type) async -> T? {
        loadFile(filename: service.rawValue, as: type)
    }
}

