//
//  OpenDotaController.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 30/6/21.
//

import Foundation
import Alamofire
import WidgetKit

let baseURL = "https://api.opendota.com"
fileprivate var loading = false

class OpenDotaController {
    
    static let shared = OpenDotaController()
    
    func searchUserByID(userid: String) async -> UserProfile? {
        let url = URL(string: "\(baseURL)/api/players/\(userid)")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            let user = try decoder.decode(SteamProfile.self, from: data)
            var userProfile = user.profile
            userProfile.rank = user.rank
            return userProfile
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func searchUserByText(text: String) async -> [UserProfile] {
        let trimText = text.replacingOccurrences(of: " ", with: "%20")
        let urlString = "\(baseURL)/api/search/?q=\(trimText)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
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
    
    static func loadUserData(userid: String, onCompletion: @escaping (SteamProfile?) -> ()) {
        let url = "\(baseURL)/api/players/\(userid)"
        AF.request(url).responseJSON { response in
            print("load user data")
            debugPrint(response)
            guard let data = response.data else {
                return
            }
            guard let statusCode = response.response?.statusCode else {
                return
            }
            if statusCode > 400 {
                DotaEnvironment.shared.exceedLimit = true
                return
            }
            let decoder = JSONDecoder()
            
            let user = try? decoder.decode(SteamProfile.self, from: data)
            var userProfile = user?.profile
            userProfile?.rank = user?.rank
            try? WCDBController.shared.database.insert(objects: [userProfile!], intoTable: "UserProfile")
            onCompletion(user)
        }
    }
    
    static func loadMatchData(matchid: String, onComplete:@escaping (Bool) -> ()) {
        let url = "\(baseURL)/api/matches/\(matchid)"
        AF.request(url).responseJSON { response in
            debugPrint(response)
            guard let data = response.data else {
                return
            }
            guard let statusCode = response.response?.statusCode else {
                return
            }
            if statusCode > 400 {
                DotaEnvironment.shared.exceedLimit = true
            }
            let decoder = JSONDecoder()
            guard let match = try? decoder.decode(Match.self, from: data) else {
                print("cannot decode match")
                print(data.description)
                onComplete(false)
                return
            }
            try? WCDBController.shared.database.insertOrReplace(objects: [match], intoTable: "Match")
            onComplete(true)
        }
    }
    
    func loadRecentMatch(userid: String, days: Double? = nil) async -> [RecentMatch] {
        var urlString = ""
        if days != nil {
            urlString = "\(baseURL)/api/players/\(userid)/matches/?date=\(days!)&&significant=0"
        } else {
            urlString = "\(baseURL)/api/players/\(userid)/matches?significant=0"
        }
        guard let url = URL(string: urlString) else {
            return []
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decoder = JSONDecoder()
            guard let matches = try? decoder.decode([RecentMatch].self, from: data) else {
                return []
            }
            matches.forEach({$0.playerId = Int(userid)})
            try WCDBController.shared.database.insertOrReplace(objects: matches, intoTable: "RecentMatch")
            print("fetched new matches for player \(userid)", matches.count)
            return matches.count >= 50 ? Array(matches[0..<50]) : matches
        } catch {
            return []
        }
        
    }
    
    static func loadHeroPortrait(url: String, onCompletion: @escaping (Data) -> ()) {
        let parse = url.replacingOccurrences(of: "/apps/dota2/images/heroes/", with: "")
        let parse2 = parse.replacingOccurrences(of: "_icon.png", with: "")
        let url = "https://cdn.cloudflare.steamstatic.com/apps/dota2/videos/dota_react/heroes/renders/\(parse2).png"
        print("loading hero portrait \(url)")
        AF.request(url).responseData { response in
            guard let data = response.data else {
                return
            }
            onCompletion(data)
        }
    }
}
