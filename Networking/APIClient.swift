//
//  APIClient.swift
//  D2A
//
//  Created by Shibo Tong on 16/5/2026.
//

import Foundation

public protocol APIClientProtocol: Sendable {
    func get(_ urlString: String) async throws -> (Data, URLResponse)
}

public final class APIClient: APIClientProtocol {
    
    public static let shared = APIClient()
    
    public let urlSession: URLSession = .shared
    
    public func get(_ urlString: String) async throws -> (Data, URLResponse) {
        let request = try createRequest(urlString, method: .get)
        return try await urlSession.data(for: request)
    }
    
    private func createRequest(_ urlString: String, method: APIHTTPMethod) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw APIClientError(message: "URL is not valid. \(urlString)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
