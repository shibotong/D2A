//
//  OpenDotaConstantsTests.swift
//  Unit Tests
//
//  Created by Shibo Tong on 9/6/2025.
//

import Testing
import UIKit
@testable import D2A

struct OpenDotaConstantsTests {

    struct MockNetwork: D2ANetworking {
        func remoteImage(_ urlString: String) async throws -> UIImage? {
            return nil
        }
        
        func dataTask<T>(_ urlString: String, as type: T.Type) async throws -> T where T: Decodable {
            throw D2AError(message: "Mock testing error")
        }
    }

    @Test("Good Network Constants")
    func loadConstantsWithGoodNetwork() async throws {

        let constantsProvider = OpenDotaConstantProvider()

        let heroes = try await constantsProvider.loadHeroes()
        let itemIDs = try await constantsProvider.loadItemIDs()
        let abilities = try await constantsProvider.loadAbilities()
        #expect(heroes.count > 0, "Heroes list should not be empty")
        #expect(itemIDs.count > 0, "item ID should not be empty")
        #expect(abilities.count > 0, "abilities should not be empty")
    }
}
