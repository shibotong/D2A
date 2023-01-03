//
//  LobbyType.swift
//  App
//
//  Created by Shibo Tong on 28/8/21.
//

import Foundation

struct LobbyType: Codable {
    var id: Int
    var name: String
    var lobbyName: String {
        switch id {
        case 0:
            return "Normal"
        case 1:
            return "Practice"
        case 2:
            return "Tournament"
        case 3:
            return "Tutorial"
        case 4:
            return "Bots"
        case 5,6,7:
            return "Ranked"
        case 8:
            return "1v1 mid"
        case 9:
            return "Battle Cup"
        case 12:
            return "Event"
        default:
            return "Unknown (\(id))"
        }
    }
}
