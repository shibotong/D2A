//
//  OpenDotaController.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 30/6/21.
//

import Foundation
import WidgetKit

let baseURL = "https://api.opendota.com"

class OpenDotaController {
    
    static let shared = OpenDotaController()
    
    let decodingService = DecodingService()
    
    func searchUserByText(text: String) async -> [UserProfileCodable] {
        let urlString = "\(baseURL)/api/search/?q=\(text)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let decoder = JSONDecoder()
            let usersCodable = try decoder.decode([UserProfileCodable].self, from: data)
            return usersCodable
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func getRecentMatches(userid: String) async -> [RecentMatch] {
        let url = URL(string: "\(baseURL)/api/players/\(userid)/recentMatches")
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let decoder = JSONDecoder()
            let recentMatches = try decoder.decode([RecentMatch].self, from: data)
            return recentMatches
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    func loadUserData(userid: String) async throws -> UserProfileCodable {
        let data = try await decodingService.loadData("/players/\(userid)")
        let userCodable = try decodingService.decodeUserProfile(data)
        return userCodable
    }
    
    func loadMatchData(matchid: String) async throws -> MatchCodable {
        let data = try await decodingService.loadData("/matches/\(matchid)")
        let matchCodable = try decodingService.decodeMatch(data: data)
        return matchCodable
    }
    
    func loadRecentMatch(userid: String, days: Double? = nil, offset: Int = 0, numbers: Int? = nil) async -> [RecentMatch] {
        var urlString = ""
        if days != nil {
            urlString = "/players/\(userid)/matches/?date=\(days!)&&significant=0"
        } else {
            urlString = "/players/\(userid)/matches?significant=0"
        }
        do {
            let data = try await decodingService.loadData(urlString)
            let matches: [RecentMatch] = try decodingService.decode(data)
            matches.forEach({$0.playerId = Int(userid)})
//            try WCDBController.shared.database.insertOrReplace(objects: matches, intoTable: "RecentMatch")
//            print("fetched new matches for player \(userid)", matches.count)
//            return matches.count >= 50 ? Array(matches[0..<50]) : matches
            if let numbers = numbers {
                return matches.count >= numbers ? Array(matches[0..<numbers]) : matches
            } else {
                return matches
            }
        } catch {
            print("error: ", error)
            return []
        }
    }
    
    func loadRecentMatches(userid: String) async -> [RecentMatch] {
        let urlString = "/players/\(userid)/recentMatches"
        do {
            let data = try await decodingService.loadData(urlString)
            let matches: [RecentMatch] = try decodingService.decode(data)
            return matches
        } catch {
            print("error: ", error)
            return []
        }
    }
}

struct DecodingService {
    func decodeMatch(data: Data) throws -> MatchCodable {
        do {
            let decoder = JSONDecoder()
            let match = try decoder.decode(MatchCodable.self, from: data)
            return match
        } catch {
            throw APIError.decodingError
        }
    }
    
    func decode<T: Decodable>(_ data: Data) throws -> T {
        do {
            let decoder = JSONDecoder()
            let match = try decoder.decode(T.self, from: data)
            return match
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            throw APIError.decodingError
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            throw APIError.decodingError
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            throw APIError.decodingError
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            throw APIError.decodingError
        }
    }
    
    func decodeRecentMatch(_ data: Data) throws -> [RecentMatch] {
        do {
            let decoder = JSONDecoder()
            let match = try decoder.decode([RecentMatch].self, from: data)
            return match
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
            return []
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return []
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return []
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
            return []
        }
    }
    
    func decodeUserProfile(_ data: Data) throws -> UserProfileCodable {
        do {
            let decoder = JSONDecoder()
            let user = try decoder.decode(SteamProfile.self, from: data)
            var userProfile = user.profile
            userProfile.rank = user.rank
            userProfile.leaderboard = user.leaderboard
            return userProfile
        } catch {
            throw error
        }
    }
    
    func loadData(_ path: String) async throws -> Data {
        let urlString = "\(baseURL)/api\(path)"
        print(urlString)
        guard let url = URL(string: urlString) else {
            throw APIError.urlError
        }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            let httpResponse = response as? HTTPURLResponse
            print("statuscode \(httpResponse?.statusCode ?? 0)")
            if httpResponse?.statusCode == 200 {
                return data
            } else if httpResponse?.statusCode == 400 {
                await self.setError(APIError.invalidError)
                throw APIError.invalidError
            } else {
                throw APIError.accessError
            }
        } catch {
            print(error)
            throw APIError.networkError
        }
    }
    
    @MainActor func setError(_ error: APIError) {
        switch error {
        case .invalidError:
            DotaEnvironment.shared.error = true
            DotaEnvironment.shared.errorMessage = "Invalid Account ID"
        default:
            DotaEnvironment.shared.error = true
            DotaEnvironment.shared.errorMessage = "You are so quick!"
        }
    }
}

enum APIError: LocalizedError {
    case urlError
    case decodingError
    case networkError
    case accessError
    case invalidError
}
