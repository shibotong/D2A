//
//  OpenDotaConstantFetcherTests.swift
//  D2A
//
//  Created by Shibo Tong on 20/5/2026.
//

import Testing
import TestKit
import Foundation
@testable import OpenDota

@Suite(.serialized)
struct OpenDotaConstantFetcherTests {
    
    let fetcher: OpenDotaConstantFetcher
    let fileReader: FileReader
    let baseURL = "https://api.opendota.com/api/constants"
    
    init() {
        fetcher = OpenDotaConstantFetcher(apiClient: MockAPIClient())
        fileReader = .shared
    }
    
    @Test("Hero data testing")
    func heroesData() async throws {
        let data = try fileReader.readFile("heroes")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "\(baseURL)/heroes")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return(response, data)
        }
        let result = try await fetcher.heroes()
        #expect(result.count == 127)
    }
    
    @Test("Ability data testing")
    func abilitiesData() async throws {
        let data = try fileReader.readFile("abilities")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "\(baseURL)/abilities")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return(response, data)
        }
        let result = try await fetcher.abilities()
        #expect(result.count == 3084)
    }
}
