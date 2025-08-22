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
        try? FileReader.loadFile(filename: service.rawValue, as: type)
    }
    
    func loadOpenDotaUser() -> ODPlayerProfile {
        try! FileReader.loadFile(filename: OpenDotaDataService.player.rawValue, as: ODPlayerProfile.self)
    }
    
    func loadOpenDotaMatch() -> ODMatch {
        try! FileReader.loadFile(filename: OpenDotaDataService.match.rawValue, as: ODMatch.self)
    }
    
    private enum OpenDotaDataService: String {
        case player
        case match
    }
}

extension PreviewDataProvider: OpenDotaConstantFetching {
    func loadService<T>(service: OpenDotaConstantService, as type: T.Type) async -> T? where T : Decodable {
        loadOpenDotaConstants(service: service, as: type)
    }
}
