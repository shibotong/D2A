//
//  StaticDataKit.swift
//  StaticDataKit
//
//  Created by Shibo Tong on 1/5/2026.
//

import Foundation

nonisolated public func readFile(_ name: String) throws -> Data {
    guard let path = Bundle.main.path(forResource: name, ofType: "json") else {
        throw StaticDataError.fileNotFound
    }
    return try Data(contentsOf: URL(fileURLWithPath: path))
}

public enum StaticDataError: Error {
    case fileNotFound
}
