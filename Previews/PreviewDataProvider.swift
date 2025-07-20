//
//  PreviewDataProvider.swift
//  D2A
//
//  Created by Shibo Tong on 20/7/2025.
//

import Foundation

#if DEBUG
class PreviewDataProvider {
    
    static let shared = PreviewDataProvider()
    
    var heroes: [String: ODHero] {
        return loadFile(filename: "heroes", as: [String: ODHero].self) ?? [:]
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
#endif
