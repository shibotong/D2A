//
//  MockNetwork.swift
//  D2A
//
//  Created by Shibo Tong on 25/9/2025.
//

import UIKit
@testable import D2A

class MockNetwork: D2ANetworking {
    
    private let error = D2AError(message: "Test error throws from mock network")
    private let fileReader: FileReader
    
    init() {
        let bundle = Bundle(for: Self.self)
        fileReader = FileReader(bundle: bundle)
    }
    
    func dataTask<T>(_ urlString: String, as type: T.Type) async throws -> T where T : Decodable {
        if urlString.contains("https://api.opendota.com/api/matches/") {
            let match = try fileReader.loadFile(filename: "test_match", as: T.self)
            return match
        }
        throw error
    }
    
    func dataTask(_ urlString: String) async throws -> Any {
        if urlString.contains("https://api.opendota.com/api/matches/") {
            let match = try fileReader.loadFile(filename: "test_match")
            return match
        }
        throw error
    }
    
    func remoteImage(_ urlString: String) async throws -> UIImage? {
        throw error
    }
}
