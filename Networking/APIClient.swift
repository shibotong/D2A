//
//  APIClient.swift
//  D2A
//
//  Created by Shibo Tong on 16/5/2026.
//

import Foundation

public protocol APIClientProtocol: Sendable {
    var urlSession: URLSession { get }
}

extension APIClientProtocol {
    public func url(_ url: URL) async throws -> Data {
        let request = URLRequest(url: url)
        return try await self.request(request)
    }
    
    public func url<T: Decodable & Sendable>(_ url: URL, decoder: JSONDecoder, as type: T.Type) async throws -> T {
        let data = try await self.url(url)
        return try decoder.decode(T.self, from: data)
    }
    
    public func request(_ request: URLRequest) async throws -> Data {
        let (data, response) = try await urlSession.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            return data
        }
        
        switch httpResponse.statusCode {
        case 200:
            return data
        case 404:
            throw URLError(URLError.Code(rawValue: 404), userInfo: ["error": "Not Found"])
        default:
            return data
        }
    }
    
    public func request<T: Decodable & Sendable>(_ request: URLRequest, decoder: JSONDecoder, as type: T.Type) async throws -> T {
        let data = try await self.request(request)
        return try decoder.decode(T.self, from: data)
    }
}

public class APIClient: APIClientProtocol {
    public static let shared = APIClient()
    
    public let urlSession: URLSession = .shared
}

extension URLError {
    public static let notFound: URLError = URLError(URLError.Code(rawValue: 404), userInfo: ["error": "Not Found"])
}
