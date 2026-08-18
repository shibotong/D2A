//
//  MockAPIClient.swift
//  D2A
//
//  Created by Shibo Tong on 16/5/2026.
//

import Networking
import Foundation

public final class MockAPIClient: APIClientProtocol, @unchecked Sendable {
    
    public var getReturnValue: Data!
    public var getThrowError: Error?
    
    public init() {}
    
    public func get(_ urlString: String) async throws -> Data {
        if let getThrowError {
            throw getThrowError
        }
        return getReturnValue
    }
}
