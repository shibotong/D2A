//
//  LiveMatchActivityAttributes.swift
//  D2A
//
//  Created by Shibo Tong on 15/6/2023.
//

import Foundation
import ActivityKit

struct LiveMatchActivityAttributes: ActivityAttributes {
    public typealias MatchStatus = ContentState

    public struct ContentState: Codable, Hashable {
        var radiantScore: Int
        var direScore: Int
        var time: Int
    }
    var radiantTeam: String?
    var direTeam: String?
}
