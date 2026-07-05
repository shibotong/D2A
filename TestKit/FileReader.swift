//
//  FileReader.swift
//  D2A
//
//  Created by Shibo Tong on 16/5/2026.
//

import Foundation

public class FileReader {
    
    public static let shared = FileReader()
    
    let bundle: Bundle
    
    public init() {
        self.bundle = Bundle(for: Self.self)
    }
    
    public func readFile(_ name: String) throws -> Data {
        guard let path = bundle.path(forResource: name, ofType: "json") else {
            throw TestKitError.fileNotFound
        }
        return try Data(contentsOf: URL(fileURLWithPath: path))
    }
}
