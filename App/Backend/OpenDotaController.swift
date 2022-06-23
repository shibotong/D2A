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
    
    func searchUserByText(text: String) async -> [UserProfile] {
//        let trimText = text.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(baseURL)/api/search/?q=\(text)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: urlString)
        do {
            let (data, _) = try await URLSession.shared.data(from: url!)
            let decoder = JSONDecoder()
            let users = try decoder.decode([UserProfile].self, from: data)
            return users
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
    
    func loadUserData(userid: String) async -> UserProfile? {
        do {
            let data = try await decodingService.loadData("/players/\(userid)")
            let user = try decodingService.decodeUserProfile(data)
//            WCDBController.shared.deleteUser(userid: userid)
//            try WCDBController.shared.database.insertOrReplace(objects: [user], intoTable: "UserProfile")
            return user
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func loadMatchData(matchid: String) async throws -> Match {
        do {
            let data = try await decodingService.loadData("/matches/\(matchid)")
            let match = try decodingService.decodeMatch(data: data)
            WCDBController.shared.deleteMatch(matchid: matchid)
            try WCDBController.shared.database.insertOrReplace(objects: [match], intoTable: "Match")
            return match
        } catch {
            throw error
        }
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
    
//    static func loadHeroPortrait(url: String, onCompletion: @escaping (Data) -> ()) {
//        let parse = url.replacingOccurrences(of: "/apps/dota2/images/heroes/", with: "")
//        let parse2 = parse.replacingOccurrences(of: "_icon.png", with: "")
//        let url = "https://cdn.cloudflare.steamstatic.com/apps/dota2/videos/dota_react/heroes/renders/\(parse2).png"
//        print("loading hero portrait \(url)")
//        AF.request(url).responseData { response in
//            guard let data = response.data else {
//                return
//            }
//            onCompletion(data)
//        }
//    }
}

struct DecodingService {
    func decodeMatch(data: Data) throws -> Match {
        do {
            let decoder = JSONDecoder()
            let match = try decoder.decode(Match.self, from: data)
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
    
    func decodeUserProfile(_ data: Data) throws -> UserProfile {
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
            DotaEnvironment.shared.invalidID = true
        default:
            DotaEnvironment.shared.exceedLimit = true
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
