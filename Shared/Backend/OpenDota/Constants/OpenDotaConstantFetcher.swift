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

class MockOpenDotaConstantFetcher: OpenDotaConstantFetching {
    func loadService<T: Decodable>(service: OpenDotaConstantService, as type: T.Type) async -> T? {
        var mockFileName = ""
        switch service {
        case .abilities:
            mockFileName = "abilities"
        case .heroes:
            mockFileName = "heroes"
        case .itemIDs:
            mockFileName = "itemIDs"
        default:
            mockFileName = ""
        }
        
        return loadFile(filename: mockFileName, as: type)
    }
    
    private func loadFile<T: Decodable>(filename: String, as type: T.Type) -> T? {
        guard let path = Bundle.main.url(forResource: filename, withExtension: "json"),
              let data = try? Data(contentsOf: path) else {
            return nil
        }

        let decoder = JSONDecoder()
        let jsonData = try? decoder.decode(T.self, from: data)
        return jsonData
    }
}
