//
//  readFile.swift
//  D2A
//
//  Created by Shibo Tong on 1/5/2026.
//

import Foundation

func readFile(_ name: String) throws -> Data {
    guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
        throw PreviewError.fileNotFound
    }
    return try Data(contentsOf: URL(fileURLWithPath: path))
}

enum PreviewError: Error {
    case fileNotFound
}
