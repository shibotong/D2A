//
//  D2ANetworkTests.swift
//  D2A
//
//  Created by Shibo Tong on 6/12/2025.
//

import Testing
import Foundation
import UIKit
@testable import D2A

class D2ANetworkTests {
    
    class MockDataProvider: DataProviding {
        
        var data: Data? = nil
        
        func data(urlString: String) async throws -> Data {
            guard let data else {
                throw UnitTestError(.dataNotProvided)
            }
            return data
        }
    }
    
    let network: D2ANetworking
    private var dataProvider: MockDataProvider
    
    init() {
        dataProvider = MockDataProvider()
        network = D2ANetwork(provider: dataProvider)
    }
    
    @Test("Test JSON Object")
    func jsonObject() async throws {
        let object: [String: Any] = ["userID": 1, "name": "Test User"]
        let data = try JSONSerialization.data(withJSONObject: object)
        dataProvider.data = data
        let json = try await network.jsonObject(urlString: "http://test.url")
        let test1 = try #require(json["userID"] as? Int)
        let test2 = try #require(json["name"] as? String)
        
        #expect(test1 == 1)
        #expect(test2 == "Test User")
    }
    
    @Test("Test JSON Array")
    func jsonArray() async throws {
        let array: [[String: Any]] = [["userID": 1, "name": "Test User"], ["userID": 2, "name": "Test User2"]]
        let data = try JSONSerialization.data(withJSONObject: array)
        dataProvider.data = data
        let json = try await network.jsonArray(urlString: "http://test.url")
        #expect(json.count == 2)
    }
    
    @Test("Test image")
    func image() async throws {
        let image = UIImage(named: "ability_slot")
        let data = try #require(image?.pngData())
        dataProvider.data = data
        let fetchImage = try? await network.image(urlString: "http://test.url")
        #expect(fetchImage != nil)
    }
    
    @Test
    func wrongDecodingObject() async throws {
        let array: [[String: Any]] = [["userID": 1, "name": "Test User"], ["userID": 2, "name": "Test User2"]]
        let data = try JSONSerialization.data(withJSONObject: array)
        dataProvider.data = data
        await #expect(throws: URLError(.cannotDecodeRawData)) {
            try await self.network.jsonObject(urlString: "http://test.url")
        }
    }
    
    @Test
    func wrongDecodingArray() async throws {
        let array: [String: Any] = ["userID": 1, "name": "Test User"]
        let data = try JSONSerialization.data(withJSONObject: array)
        dataProvider.data = data
        await #expect(throws: URLError(.cannotDecodeRawData)) {
            try await self.network.jsonArray(urlString: "http://test.url")
        }
    }
    
    @Test
    func wrongDecodingImage() async throws {
        let array: [[String: Any]] = [["userID": 1, "name": "Test User"], ["userID": 2, "name": "Test User2"]]
        let data = try JSONSerialization.data(withJSONObject: array)
        dataProvider.data = data
        await #expect(throws: URLError(.cannotDecodeRawData)) {
            try await self.network.image(urlString: "http://test.url")
        }
    }
}
