//
//  SearchHistory.swift
//  D2A
//
//  Created by Shibo Tong on 16/8/2025.
//

import SwiftData
import Foundation

@Model
class SearchHistory {
    var id: String
    var type: SearchType
    var lastSearchTime: Date
    
    init(id: String, type: SearchType, lastSearchTime: Date) {
        self.id = id
        self.type = type
        self.lastSearchTime = lastSearchTime
    }
}


enum SearchType {
    case hero
    case player
}
