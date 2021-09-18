//
//  OpenDotaController.swift
//  AppWidgetExtension
//
//  Created by Shibo Tong on 18/9/21.
//

import Foundation
import Alamofire

let baseURL = "https://api.opendota.com"

class OpenDotaController {
    static func loadRecentMatch(completion: @escaping ([RecentMatch], SteamProfile) -> Void) {
        let matchURL = "\(baseURL)/api/players/\("153041957")/matches/?limit=5"
        let profileURL = "\(baseURL)/api/players/\("153041957")"
        AF.request(matchURL).responseJSON { response in
            guard let data = response.data else {
                return
            }
            let decoder = JSONDecoder()
            guard let matches = try? decoder.decode([RecentMatch].self, from: data) else {
                return
            }
            AF.request(profileURL).responseJSON { response in
                guard let data = response.data else {
                    return
                }
                let decoder = JSONDecoder()
                guard let profile = try? decoder.decode(SteamProfile.self, from: data) else {
                    return
                }
                completion(matches, profile)
            }
            
        }
    }
}
