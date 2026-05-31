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
    
    init() {
        fetcher = OpenDotaConstantFetcher(apiClient: MockAPIClient())
        let fileReader = FileReader.shared
        MockURLProtocol.requestHandler = { request in
            let headerFields = ["Content-Type": "application/json"]
            let urlPath = request.url!.path
            var statusCode = 200
            let data: Data
            switch urlPath {
            case "/api/constants/heroes":
                data = try! fileReader.readFile("heroes")
            case "/api/constants/abilities":
                data = try! fileReader.readFile("abilities")
            case "/api/constants/hero_abilities":
                data = try! fileReader.readFile("hero_abilities")
            case "/api/constants/ability_ids":
                data = try! fileReader.readFile("ability_ids")
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
    
    @Test("Test hero api")
    func heroesData() async throws {
        let result = try await fetcher.heroes()
        #expect(result.count == 127)
    }
    
    @Test("Test abilities api")
    func abilitiesData() async throws {
        let result = try await fetcher.abilities()
        #expect(result.count == 3084)
    }
    
    @Test("Test hero_abilities api")
    func heroAbilitiesData() async throws {
        let result = try await fetcher.heroAbilities()
        #expect(result.count == 127)
    }
    
    @Test("Test ability_ids api")
    func abilityIDsData() async throws {
        let result = try await fetcher.abilityIDs()
        #expect(result.count == 127)
    }
}
