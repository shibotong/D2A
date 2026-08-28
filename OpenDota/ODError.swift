//
//  ODError.swift
//  D2A
//
//  Created by Shibo Tong on 22/5/2026.
//

public struct ODError: Decodable, Error {
    
    static let invalidHTTPResponse = ODError(error: "The response is not a http response.")
    static let unknown = ODError(error: "Unknown error occurred.")
    
    public let error: String
}
