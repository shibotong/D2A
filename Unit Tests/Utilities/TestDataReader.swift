//
//  TestDataReader.swift
//  D2A
//
//  Created by Shibo Tong on 9/12/2025.
//

import Foundation

struct TestDataReader {
    static func read<T>(filename: String, as type: T.Type) throws -> T {
        guard let path = Bundle.main.url(forResource: filename, withExtension: "json") else {
            throw URLError(.fileDoesNotExist)
        }
        let data = try Data(contentsOf: path)
        guard let json = try JSONSerialization.jsonObject(with: data) as? T else {
            throw URLError(.cannotDecodeContentData)
        }
        return json
    }
}
