//
//  PreviewDataProvider.swift
//  D2A
//
//  Created by Shibo Tong on 20/7/2025.
//

import Foundation

class PreviewDataProvider {
    
    static let shared = PreviewDataProvider()
    
    func loadOpenDotaConstants<T: Decodable>(service: OpenDotaConstantService, as type: T.Type) -> T? {
        loadFile(filename: service.rawValue, as: type)
    }
    
    func loadOpenDotaUser() -> ODPlayerProfile? {
        loadFile(filename: OpenDotaDataService.player.rawValue, as: ODPlayerProfile.self)
    }
    
    private enum OpenDotaDataService: String {
        case player
    }
    
    private func loadFile<T: Decodable>(filename: String, as type: T.Type) -> T? {
        guard let path = Bundle.main.url(forResource: filename, withExtension: "json") else {
            assertionFailure("Not able to find file \(filename).json")
            return nil
        }
        let data = try! Data(contentsOf: path)
        let decoder = JSONDecoder()
        let jsonData = try! decoder.decode(T.self, from: data)
        return jsonData
    }
}

extension PreviewDataProvider: OpenDotaConstantFetching {
    func loadService<T>(service: OpenDotaConstantService, as type: T.Type) async -> T? where T : Decodable {
        loadOpenDotaConstants(service: service, as: type)
    }
}
