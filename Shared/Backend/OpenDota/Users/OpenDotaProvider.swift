//
//  OpenDotaController.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 30/6/21.
//

import Foundation
import WidgetKit

protocol OpenDotaProviding {
    func searchUserByText(text: String) async -> [ODUserProfile]
    func loadUserData(userid: String) async throws -> ODUserProfile

    func getRecentMatches(userid: String) async -> [RecentMatchCodable]
    func loadMatch(id: String) async throws -> ODMatch
    func loadRecentMatch(userid: String) async
    func loadRecentMatch(userid: String, days: Double?) async
    func loadRecentMatches(userid: String) async -> [RecentMatchCodable]
}

class OpenDotaProvider: OpenDotaProviding {

    static let shared = OpenDotaProvider()

    private let baseURL = "https://api.opendota.com"

    func searchUserByText(text: String) async -> [ODUserProfile] {
        let urlString = "\(baseURL)/api/search/?q=\(text)".addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed)!
        do {
            return try await D2ANetwork.default.dataTask(urlString, as: [ODUserProfile].self)
        } catch {
            logError(
                "Search user by text failed: \(error.localizedDescription)", category: .opendota)
            return []
        }
    }

    func loadUserData(userid: String) async throws -> ODUserProfile {
        let user = try await loadData("/players/\(userid)", as: SteamProfile.self)
        var userProfile = user.profile
        userProfile.rank = user.rank
        userProfile.leaderboard = user.leaderboard
        return userProfile
    }

    func getRecentMatches(userid: String) async -> [RecentMatchCodable] {
        do {
            let recentMatches = try await loadData("/players/\(userid)/recentMatches", as: [RecentMatchCodable].self)
            return recentMatches
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func loadMatch(id: String) async throws -> ODMatch {
        let match = try await loadData("/matches/\(id)", as: ODMatch.self)
        return match
    }

    func loadRecentMatch(userid: String) async {
        guard EnvironmentController.shared.canRefresh(userid: userid) else {
            return
        }
        let latestMatches = RecentMatch.fetch(userID: userid, count: 1)
        var days: Double?
        // here should be timeIntervalSinceNow
        if let lastMatchStartTime = latestMatches.first?.startTime?.timeIntervalSinceNow {
            let oneDay: Double = 60 * 60 * 24

            // Decrease 1 sec to avoid adding repeated match
            days = -(lastMatchStartTime + 1) / oneDay
        }
        await loadRecentMatch(userid: userid, days: days)
    }

    func loadRecentMatch(userid: String, days: Double?) async {
        var urlString = ""
        if days != nil {
            urlString = "/players/\(userid)/matches/?date=\(days!)&&significant=0"
        } else {
            urlString = "/players/\(userid)/matches?significant=0"
        }
        do {
            let matches = try await loadData(urlString, as: [RecentMatchCodable].self)
            matches.forEach({ $0.playerId = Int(userid) })
            try await RecentMatch.create(matches)
        } catch {
            print("error: ", error)
            return
        }
    }

    func loadRecentMatches(userid: String) async -> [RecentMatchCodable] {
        let urlString = "/players/\(userid)/recentMatches"
        do {
            let matches = try await loadData(urlString, as: [RecentMatchCodable].self)

            return matches
        } catch {
            print("error: ", error)
            return []
        }
    }

    /// Load data with path `\(baseURL)/api`
    private func loadData<T: Decodable>(_ path: String, as type: T.Type) async throws -> T {
        let urlString = "\(baseURL)/api\(path)"
        return try await D2ANetwork.default.dataTask(urlString, as: T.self)
    }
}
