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

struct OpenDotaConstantFetcherTests {
    
    let fetcher: OpenDotaConstantFetcher
    let fileReader: FileReader
    
    init() {
        fetcher = OpenDotaConstantFetcher(apiClient: MockAPIClient())
        fileReader = .shared
    }
    
    @Test("Hero data testing")
    func heroesData() async throws {
        let data = try fileReader.readFile("heroes")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://api.opendota.com")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return(response, data)
        }
        let result = try await fetcher.heroes()
        #expect(result.count == 127)
    }
}
