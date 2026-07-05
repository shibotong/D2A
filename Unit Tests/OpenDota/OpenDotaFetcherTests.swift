//
//  OpenDotaFetcherTests.swift
//  D2A
//
//  Created by Shibo Tong on 5/7/2026.
//

import Testing
import TestKit
import Foundation
@testable import OpenDota

struct OpenDotaFetcherTests {
    
    let fetcher: OpenDotaFetching
    
    init() {
        fetcher = OpenDotaFetcher(apiClient: MockAPIClient())
        let fileReader = FileReader.shared
        MockURLProtocol.requestHandler = { request in
            let headerFields = ["Content-Type": "application/json"]
            let urlPath = request.url!.path
            var statusCode = 200
            let data: Data
            switch urlPath {
            case "/api/players/321580662":
                data = try! fileReader.readFile("player_yatoro")
            default:
                statusCode = 401
                data = "error".data(using: .utf8)!
            }
            let response = HTTPURLResponse(url: request.url!,
                                           statusCode: statusCode,
                                           httpVersion: nil,
                                           headerFields: headerFields)!
            return(response, data)
        }
        
    }
    
    @Test("Test yatoro user profile")
    func profile() async throws {
        let user = try await fetcher.profile(id: "321580662")
        let profile = user.profile
        #expect(user.rankTier == 80)
        #expect(user.leaderboardRank == 12)
        #expect(user.computedMmr == nil)
        #expect(user.computedMmrTurbo == nil)
        #expect(profile.accountId == 321580662)
    }
}
