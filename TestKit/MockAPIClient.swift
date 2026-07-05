//
//  MockAPIClient.swift
//  D2A
//
//  Created by Shibo Tong on 16/5/2026.
//

import Networking
import Foundation

public struct MockAPIClient: APIClientProtocol {
    
    public init() {}
    
    public var urlSession: URLSession {
        let configuration: URLSessionConfiguration = .ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
}

nonisolated
public class MockURLProtocol: URLProtocol {
    nonisolated(unsafe) public static var error: Error?
    nonisolated(unsafe) public static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
    
    public override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    public override func startLoading() {
        if let error = MockURLProtocol.error {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        
        guard let handler = MockURLProtocol.requestHandler else {
            assertionFailure("Received unexpected request with no handler set")
            return
        }
        
        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }
    
    public override func stopLoading() {
        // TODO: Andd stop loading here
    }
}
