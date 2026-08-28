//
//  ODSearchPlayer.swift
//  D2A
//
//  Created by Shibo Tong on 28/8/2026.
//

import Foundation

public struct ODSearchPlayer: Decodable, Identifiable {
    
    public var id: Int {
        return accountId
    }
    
    public let accountId: Int
    public let avatarfull: String
    public let personaname: String
    public let lastMatchTime: Date?
    public let sml: Int?
}
