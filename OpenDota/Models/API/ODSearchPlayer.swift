//
//  ODSearchPlayer.swift
//  D2A
//
//  Created by Shibo Tong on 28/8/2026.
//

import Foundation

public struct ODSearchPlayer: Decodable {
    public let accountId: Int
    public let avatarfull: String
    public let personaname: String
    public let lastMatchTime: Date
    public let sml: Int
}
