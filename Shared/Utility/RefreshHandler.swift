//
//  RefreshHandler.swift
//  D2A
//
//  Created by Shibo Tong on 9/7/2025.
//

import Foundation

actor RefreshHandler {
    
    static let shared = RefreshHandler()
    
    var cache: [String: TimeInterval] = [:]
    
    private let refreshDistance: TimeInterval = {
        var refreshTime: TimeInterval = 60
        #if DEBUG
            refreshTime = 1
        #endif
        return refreshTime
    }()
    
    /// Check if user can refresh this player (Debug mode 1s Release mode 60s)
    /// - parameters:
    /// - userid: Player ID
    /// - Returns: Returns a `Bool` value of if user can refresh this player
    func canRefresh(userid: String) -> Bool {
        let currentTime = Date().timeIntervalSince1970
        guard let lastRefresh = cache[userid] else {
            cache[userid] = currentTime
            return true
        }

        let distance = currentTime - lastRefresh
        guard distance > refreshDistance else {
            print("last refresh \(distance)s before, cannot refresh")
            return false
        }
        cache[userid] = currentTime
        return true
    }
}
