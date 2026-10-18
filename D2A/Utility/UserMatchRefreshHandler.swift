//
//  UserMatchRefreshHandler.swift
//  D2A
//
//  Created by Shibo Tong on 18/10/2026.
//

import Foundation

actor UserMatchRefreshHandler {
    
    static let shared = UserMatchRefreshHandler()
    
    private var refreshHandler: [String: TimeInterval] = [:]
    
    private var refreshDistance: TimeInterval {
        var refreshTime: TimeInterval = 60
        #if DEBUG
        refreshTime = 1
        #endif
        return refreshTime
    }
    
    /// Check if user can refresh this player (Debug mode 1s Release mode 60s)
    /// - parameters:
    /// - userid: Player ID
    /// - Returns: Returns a `Bool` value of if user can refresh this player
    func canRefresh(userid: String) -> Bool {
        let currentTime = Date().timeIntervalSince1970
        guard let lastRefresh = refreshHandler[userid] else {
            refreshHandler[userid] = currentTime
            return true
        }
        
        let distance = currentTime - lastRefresh
        if distance > refreshDistance {
            refreshHandler[userid] = currentTime
            return true
        } else {
            print("last refresh \(distance)s before, cannot refresh")
            return false
        }
    }
}
