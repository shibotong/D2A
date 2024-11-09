//
//  DotaConstantController.swift
//  D2A
//
//  Created by Shibo Tong on 9/11/2024.
//

import Foundation

protocol ConstantController {
    func getHeroConstants() async -> [HeroCodable]
}

class DotaConstantController: ConstantController {
    static let shared = DotaConstantController()
    
    func getHeroConstants() async -> [HeroCodable] {
        let urlString = "https://api.opendota.com/api/herostats"
        
        guard let url = URL(string: urlString) else {
            D2ALogger.shared.log("url is not a valid url", level: .error)
            return []
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let heroData = try decoder.decode([HeroCodable].self, from: data)
            D2ALogger.shared.log("Hero data fetch successful. Number of heroes \(heroData.count)", level: .info)
            return heroData
        } catch {
            D2ALogger.shared.log("Error occured when fetching hero data \(error.localizedDescription)", level: .error)
            return []
        }
    }
}
