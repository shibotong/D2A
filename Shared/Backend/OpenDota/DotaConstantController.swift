//
//  DotaConstantController.swift
//  D2A
//
//  Created by Shibo Tong on 9/11/2024.
//

import Foundation

protocol ConstantController {
    func loadData<T: Decodable>(urlPath: DataPath, decodable: T.Type) async -> T?
}

enum DataPath: String {
    case hero = "https: //api.opendota.com/api/herostats"
    case ability = "https://raw.githubusercontent.com/odota/dotaconstants/master/build/abilities.json"
}

class DotaConstantController: ConstantController {
    static let shared = DotaConstantController()
    
    func loadData<T: Decodable>(urlPath: DataPath, decodable: T.Type) async -> T? {
        guard let url = URL(string: urlPath.rawValue) else {
            D2ALogger.shared.log("url is not a valid url", level: .error)
            return nil
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let results = try decoder.decode(T.self, from: data)
            D2ALogger.shared.log("Data fetch successful. \(urlPath.rawValue)", level: .info)
            return results
        } catch {
            D2ALogger.shared.log("Error occured when fetching data from \(urlPath.rawValue). Error: \(error.localizedDescription)", level: .error)
            return nil
        }
    }
}
