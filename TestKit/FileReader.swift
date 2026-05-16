//
//  FileReader.swift
//  D2A
//
//  Created by Shibo Tong on 16/5/2026.
//

import Foundation

class FileReader {
    
    static let shared = FileReader()
    
    let bundle: Bundle
    
    init() {
        self.bundle = Bundle(for: Self.self)
    }
    
    func readFile(_ name: String) throws -> Data {
        guard let path = bundle.path(forResource: name, ofType: "json") else {
            throw TestKitError.fileNotFound
        }
        return try Data(contentsOf: URL(fileURLWithPath: path))
    }
}
