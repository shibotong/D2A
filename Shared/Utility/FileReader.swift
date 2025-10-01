//
//  FileReader.swift
//  D2A
//
//  Created by Shibo Tong on 25/9/2025.
//

import Foundation

struct FileReader {
    
    static let shared = FileReader()
    
    private let bundle: Bundle
    
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }
    
    func loadFile<T: Decodable>(filename: String, as type: T.Type) throws -> T {
        let data = try loadFileContent(filename: filename)
        let decoder = JSONDecoder()
        let jsonData = try decoder.decode(T.self, from: data)
        return jsonData
    }
    
    func loadFile(filename: String) throws -> Any {
        let data = try loadFileContent(filename: filename)
        return try JSONSerialization.jsonObject(with: data)
    }
    
    private func loadFileContent(filename: String) throws -> Data {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            throw D2AError(message: "Not able to find file \(filename).json")
        }
        
        return try Data(contentsOf: path)
    }
}
