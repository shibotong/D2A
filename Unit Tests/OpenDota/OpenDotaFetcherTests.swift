//
//  OpenDotaFetcherTests.swift
//  D2A
//
//  Created by Shibo Tong on 16/5/2026.
//

import Testing
import OpenDota
import TestKit
import Foundation

struct OpenDotaFetcherTests {
    let fetcher: OpenDotaFetcher
    let client: MockNetworking
    let fileReader: FileReader
    
    init() {
        self.client = MockNetworking()
        self.fetcher = OpenDotaFetcher(client: client)
        fileReader = FileReader()
    }
    
    @Test
    func fetchHeroes() async throws {
        let data = try fileReader.readFile("heroes")
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: URL(string: "https://api.opendota.com")!,
                                           statusCode: 200,
                                           httpVersion: nil,
                                           headerFields: ["Content-Type": "application/json"])!
            return(response, data)
        }
        let heroes = try #require(await fetcher.constants(service: .heroes) as? [String: Any])
        let antimage = try #require(heroes["1"] as? [String: Any])
        let heroID = try #require(antimage["id"] as? Int)
        #expect(heroID == 1)
    }
}
