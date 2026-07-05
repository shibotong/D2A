//
//  Decoder.swift
//  D2A
//
//  Created by Shibo Tong on 5/7/2026.
//

import Foundation

let snakeDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    decoder.dateDecodingStrategy = .iso8601
    return decoder
}()
