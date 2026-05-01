//
//  readFile.swift
//  D2A
//
//  Created by Shibo Tong on 1/5/2026.
//

import Foundation

nonisolated func readFile(_ name: String) throws -> Data? {
    guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
        return nil
    }
    return try Data(contentsOf: URL(fileURLWithPath: path))
}
