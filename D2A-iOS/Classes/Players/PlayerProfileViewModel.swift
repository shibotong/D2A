//
//  PlayerProfileViewModel.swift
//  D2A
//
//  Created by Shibo Tong on 12/8/2025.
//

import Foundation
import CoreData

extension PlayerProfileView {
    struct ViewModel: Observable {
        var imageURL: String?
        var personaname: String = ""
        var name: String?
        
        var isPlus: Bool = false
        var rank: Int = 0
        var leaderboard: Int?
        
        var isRegistered: Bool = false
        var isFavourite: Bool = false
    }
}

extension PlayerView {
    struct ViewModel: Observable {
        var userID: Int
        var imageURL: String?
        var personaname: String
        var name: String?
        
        var isPlus: Bool
        var rank: Int
        var leaderboard: Int
    }
}
