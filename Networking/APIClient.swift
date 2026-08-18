//
//  APIClient.swift
//  D2A
//
//  Created by Shibo Tong on 16/5/2026.
//

import Foundation

public protocol APIClientProtocol: Sendable {
    func get(_ urlString: String) async throws -> Data
}

extension APIClientProtocol {
    public func get<T: Decodable & Sendable>(_ urlString: String, decoder: JSONDecoder, as type: T.Type) async throws -> T {
        let data = try await get(urlString)
        return try decoder.decode(T.self, from: data)
    }
}

public final class APIClient: APIClientProtocol {
    public static let shared = APIClient()
    
    public let urlSession: URLSession = .shared
    
    public func get(_ urlString: String) async throws -> Data {
        let request = try createRequest(urlString, method: .get)
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
    
    private func createRequest(_ urlString: String, method: APIHTTPMethod) throws -> URLRequest {
        guard let url = URL(string: urlString) else {
            throw APIClientError(message: "URL is not valid. \(urlString)")
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}

extension URLError {
    public static let notFound: URLError = URLError(URLError.Code(rawValue: 404), userInfo: ["error": "Not Found"])
}
