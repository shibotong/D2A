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
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = CoreDataController.shared.container.viewContext
            let user = try? decoder.decode(SteamProfile.self, from: data)
            CoreDataController.shared.saveContext()
            onCompletion(user)
        }
    }
    
    static func loadMatchData(matchid: String, onComplete:@escaping (Match?) -> ()) {
        let url = "\(baseURL)/api/matches/\(matchid)"
        AF.request(url).responseJSON { response in
            print("load match data")
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
            onComplete(match)
        }
    }
    
    static func loadRecentMatch(userid: String, offSet: Int, limit: Int, onComplete: @escaping ([RecentMatch]) -> ()) {
        let url = "\(baseURL)/api/players/\(userid)/matches/?limit=\(limit)&offset=\(offSet)"
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
            decoder.userInfo[CodingUserInfoKey.managedObjectContext] = CoreDataController.shared.container.viewContext
            let matches = try? decoder.decode([RecentMatch].self, from: data)
            print(matches)
            matches?.forEach({ match in
                match.playerId = Int64(userid)!
            })
            
            CoreDataController.shared.saveContext()
            guard let guardMatches = matches else {
                onComplete([])
                return
            }
            onComplete(guardMatches)
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
