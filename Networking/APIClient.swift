//
//  APIClient.swift
//  D2A
//
//  Created by Shibo Tong on 16/5/2026.
//

import Foundation

public protocol APIClientProtocol: Sendable {
    var urlSession: URLSession { get }
    func request(_ request: URLRequest) async throws -> Data
}

extension APIClientProtocol {
    public func url(_ url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        return try await self.request(request)
    }
}

public class APIClient: APIClientProtocol {
    
    public static let shared = APIClient()
    
    public let urlSession: URLSession = .shared
    
    public func request(_ request: URLRequest) async throws -> Data {
        let (data, _) = try await urlSession.data(for: request)
        return data
    }
}
