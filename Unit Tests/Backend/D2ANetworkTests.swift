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
    
    let network: NetworkProviding
    private var dataProvider: MockDataProvider
    
    init() {
        dataProvider = MockDataProvider()
        network = NetworkProvider(provider: dataProvider)
    }
    
    @Test("Test JSON")
    func json() async throws {
        let object: [String: Any] = ["userID": 1, "name": "Test User"]
        dataProvider.add(data: object)
        let json = try await network.json(urlString: "http://test.url", as: [String: Any].self)
        let test1 = try #require(json["userID"] as? Int)
        let test2 = try #require(json["name"] as? String)
        
        #expect(test1 == 1)
        #expect(test2 == "Test User")
    }
    
    @Test("Test image")
    func image() async throws {
        let image = try #require(UIImage(named: "ability_slot"))
        dataProvider.add(image: image)
        let fetchImage = try? await network.image(urlString: "http://test.url")
        #expect(fetchImage != nil)
    }
    
    @Test
    func wrongDecoding() async throws {
        let array: [[String: Any]] = [["userID": 1, "name": "Test User"], ["userID": 2, "name": "Test User2"]]
        dataProvider.add(data: array)
        await #expect(throws: URLError(.cannotDecodeRawData)) {
            try await self.network.json(urlString: "http://test.url", as: [String: Any].self)
        }
    }
    
    @Test
    func wrongDecodingImage() async throws {
        let array: [[String: Any]] = [["userID": 1, "name": "Test User"], ["userID": 2, "name": "Test User2"]]
        dataProvider.add(data: array)
        await #expect(throws: URLError(.cannotDecodeRawData)) {
            try await self.network.image(urlString: "http://test.url")
        }
    }
}
