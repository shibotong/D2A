//
//  APIClient.swift
//  D2A
//
//  Created by Shibo Tong on 16/5/2026.
//

import Foundation

public protocol APIClientProtocol: Sendable {
    func get(_ urlString: String, query: [String: String]) async throws -> (Data, URLResponse)
}

extension APIClientProtocol {
    public func get(_ urlString: String) async throws -> (Data, URLResponse) {
        return try await get(urlString, query: [:])
    }
}

public final class APIClient: APIClientProtocol {
    
    public static let shared = APIClient()
    
    public let urlSession: URLSession = .shared
    
    public func get(_ urlString: String, query: [String: String]) async throws -> (Data, URLResponse) {
        let request = try createRequest(urlString, method: .get, query: query)
        return try await urlSession.data(for: request)
    }
    
    private func createRequest(_ urlString: String, method: APIHTTPMethod, query: [String: String]) throws(APIClientError) -> URLRequest {
        let queryItems = query.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = URL(string: urlString)?.appending(queryItems: queryItems) else {
            throw APIClientError(message: "URL is not valid. \(urlString)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
