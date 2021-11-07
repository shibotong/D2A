//
//  OpenDotaController.swift
//  Dota Portfolio
//
//  Created by Shibo Tong on 30/6/21.
//

import Foundation
import Alamofire

let baseURL = "https://api.opendota.com"
fileprivate var loading = false

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
    
    static func loadRecentMatch(userid: String, days: Double? = nil, allmatches: Bool = false, onComplete: @escaping (Double) -> ()) {
        var url = ""
        if days != nil {
            url = "\(baseURL)/api/players/\(userid)/matches/?date=\(days!)&&significant=0"
        } else {
            url = "\(baseURL)/api/players/\(userid)/matches?significant=0"
        }
        AF.request(url).responseJSON { response in
            guard let data = response.data else {
                return
            }
            guard let statusCode = response.response?.statusCode else {
                return
            }
            if statusCode > 400 {
                DotaEnvironment.shared.exceedLimit = true
                onComplete(0.0)
            }
            let decoder = JSONDecoder()
            guard let matches = try? decoder.decode([RecentMatch].self, from: data) else {
                return
            }
            matches.forEach({$0.playerId = Int(userid)})
            print("fetched new matches for player \(userid)", matches.count)
            let queue = DispatchQueue(label: "com.d2a.calculate")
            queue.async {
                if matches.count > 0 {
                    let total = matches.count
                    var finished = 0
                    matches.forEach { match in
                        if let _ = WCDBController.shared.fetchRecentMatch(userid: userid, matchid: match.id) {
                            WCDBController.shared.deleteRecentMatch(matchid: match.id, userid: Int(userid)!)
                        }
                        try? WCDBController.shared.database.insert(objects: [match], intoTable: "RecentMatch")
                        finished += 1
                        onComplete(Double(finished) / Double(total))
                    }
                }
            }
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
