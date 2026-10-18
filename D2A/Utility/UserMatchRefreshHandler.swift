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
    private let refreshDistance: TimeInterval
    private let logger: D2ALogger
    private let currentTime: @Sendable () -> TimeInterval
    
    private static var defaultRefreshDistance: TimeInterval {
        var refreshTime: TimeInterval = 60
        #if DEBUG
        refreshTime = 1
        #endif
        return refreshTime
    }

    init(
        refreshDistance: TimeInterval = defaultRefreshDistance,
        currentTime: @escaping @Sendable () -> TimeInterval = { Date().timeIntervalSince1970 },
        logger: D2ALogger = .shared
    ) {
        self.refreshDistance = refreshDistance
        self.currentTime = currentTime
        self.logger = logger
    }
    
    /// Check if user can refresh this player (Debug mode 1s Release mode 60s)
    /// - parameters:
    /// - userid: Player ID
    /// - Returns: Returns a `Bool` value of if user can refresh this player
    func canRefresh(userid: String) -> Bool {
        let currentTime = currentTime()
        guard let lastRefresh = refreshHandler[userid] else {
            refreshHandler[userid] = currentTime
            return true
        }
        
        let distance = currentTime - lastRefresh
        if distance > refreshDistance {
            refreshHandler[userid] = currentTime
            logger.trace("User \(userid) can refresh this time.", category: .user)
            return true
        } else {
            logger.debug("User \(userid) last refresh \(distance)s before, cannot refresh", category: .user)
            return false
        }
    }
}
