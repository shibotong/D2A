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

    func loadMatch(id: String) async throws -> ODMatch
//    func loadRecentMatch(userid: String) async -> [ODRecentMatch]
    func loadRecentMatch(userid: String, days: Double?) async -> [ODRecentMatch]
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
    
    func loadMatch(id: String) async throws -> ODMatch {
        let match = try await loadData("/matches/\(id)", as: ODMatch.self)
        return match
    }

    func loadRecentMatch(userid: String, days: Double?) async -> [ODRecentMatch] {
        var urlString = ""
        if let days {
            urlString = "/players/\(userid)/matches/?date=\(days)&&significant=0"
        } else {
            urlString = "/players/\(userid)/matches?significant=0"
        }
        do {
            let matches = try await loadData(urlString, as: [ODRecentMatch].self)
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
