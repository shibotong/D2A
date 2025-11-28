//
//  OpenDotaProvider.swift
//  D2A
//
//  Created by Shibo Tong on 28/11/2025.
//

import Logging

enum OpenDotaConstantService: String {
    case heroes
}

protocol OpenDotaProviding {
    func constants(service: OpenDotaConstantService) async throws -> [String: Any]
}

struct OpenDotaProvider: OpenDotaProviding {
    
    private let baseURL = "https://api.opendota.com/api/"
    
    private let network: NetworkProviding
    
    init(network: NetworkProviding = D2ANetworkProvider.shared) {
        self.network = network
    }
    
    func constants(service: OpenDotaConstantService) async throws -> [String: Any] {
        let urlString = "\(baseURL)constants/\(service.rawValue)"
        guard let json = try await network.request(urlString: urlString) as? [String: Any] else {
            logger.error("return value from \(urlString) is not [String: Any]")
            return [:]
        }
        return json
    }
}
