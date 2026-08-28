//
//  MockAPIClient.swift
//  D2A
//
//  Created by Shibo Tong on 16/5/2026.
//

import Networking
import Foundation

public final class MockAPIClient: APIClientProtocol, @unchecked Sendable {
    
    public var getHandler: ((String) async throws -> (Data, URLResponse))!
    public var getCount: Int = 0
    
    public init() {}
    
    public func get(_ urlString: String, query: [String: String]) async throws -> (Data, URLResponse) {
        getCount += 1
        return try await getHandler(urlString)
    }
}
