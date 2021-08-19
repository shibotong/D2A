//
//  OpenDotaController.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 30/6/21.
//

import Foundation
import Alamofire

let baseURL = "https://api.opendota.com"

class OpenDotaController {
    
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
            }
            let decoder = JSONDecoder()
            
            let user = try? decoder.decode(SteamProfile.self, from: data)
            try? WCDBController.shared.database.insert(objects: [user!.profile], intoTable: "UserProfile")
            onCompletion(user)
        }
    }
    
    static func loadMatchData(matchid: String, onComplete:@escaping (Bool) -> ()) {
        let url = "\(baseURL)/api/matches/\(matchid)"
        AF.request(url).responseJSON { response in
            print("load match data")
            print(url)
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
            let match = try? decoder.decode(Match.self, from: data)
            print("loaded match \(match)")
            guard let match = match else {
                return
            }
            try? WCDBController.shared.database.insert(objects: [match], intoTable: "Match")
            onComplete(true)
        }
    }
    
    static func loadRecentMatch(userid: String, days: Double? = nil, onComplete: @escaping (Bool) -> ()) {
        var url = ""
        if days != nil {
            url = "\(baseURL)/api/players/\(userid)/matches/?date=\(days!)"
        } else {
            url = "\(baseURL)/api/players/\(userid)/matches"
        }
        AF.request(url).responseJSON { response in
            print("load matches data")
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
            let matches = try? decoder.decode([RecentMatch].self, from: data)
            guard let matches = matches else {
                return
            }
            matches.forEach({$0.playerId = Int(userid)})
            print(matches.count)
            try? WCDBController.shared.database.insert(objects: matches, intoTable: "RecentMatch")
            onComplete(true)
        }
    }
    
    static func loadItemImg(url: String, onCompletion: @escaping (Data) -> ()) {
        let url = "\(baseURL)\(url)"
        AF.request(url).responseData { response in
            print("load item img data")
            guard let data = response.data else {
                return
            }
            guard let statusCode = response.response?.statusCode else {
                return
            }
            if statusCode > 400 {
                DotaEnvironment.shared.exceedLimit = true
            }
            onCompletion(data)
        }
    }
    
    static func loadHeroPortrait(url: String, onCompletion: @escaping (Data) -> ()) {
        // /apps/dota2/images/heroes/dark_seer_icon.png
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
