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
    func fetchRecentMatches(userID: String, days: Double?) async -> [RecentMatchCodable]

    func getRecentMatches(userid: String) async -> [RecentMatchCodable]
    func loadMatchData(matchid: String) async throws -> String
    func loadRecentMatches(userid: String) async -> [RecentMatchCodable]
    
    func user(id: String) async throws -> ODPlayerProfile
}

class OpenDotaProvider: OpenDotaProviding {

    static let shared = OpenDotaProvider()

    private let baseURL = "https://api.opendota.com"
    
    private let network: D2ANetworking
    
    init(network: D2ANetworking = D2ANetwork.default) {
        self.network = network
    }

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
    
    func user(id: String) async throws -> ODPlayerProfile {
        let user = try await loadData("/players/\(id)", as: ODPlayerProfile.self)
        return user
    }

    func getRecentMatches(userid: String) async -> [RecentMatchCodable] {
        do {
            let recentMatches = try await loadData(
                "/players/\(userid)/recentMatches", as: [RecentMatchCodable].self)
            return recentMatches
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func fetchRecentMatches(userID: String, days: Double?) async -> [RecentMatchCodable] {
        var urlString = ""
        if let days {
            urlString = "/players/\(userID)/matches/?date=\(days)&&significant=0"
        } else {
            urlString = "/players/\(userID)/matches?significant=0"
        }
        do {
            let matches = try await loadData(urlString, as: [RecentMatchCodable].self)
            return matches
        } catch {
            logError("Not able to fetch recent match for \(userID). error: \(error.localizedDescription)", category: .opendota)
            return []
        }
    }

    func loadMatchData(matchid: String) async throws -> String {
        let match = try await loadData("/matches/\(matchid)", as: ODMatch.self)
        do {
            _ = try Match.create(match)
            return matchid
        } catch {
            print("Match created failed")
            throw error
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
        return try await network.dataTask(urlString, as: T.self)
    }
}
