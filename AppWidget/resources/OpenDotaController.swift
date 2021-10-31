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
    static func loadRecentMatch(id: String, completion: @escaping ([RecentMatch]) -> Void) {
        let matchURL = "\(baseURL)/api/players/\(id)/matches/?limit=5&&significant=0"
        
        AF.request(matchURL).responseJSON { response in
            guard let data = response.data else {
                return
            }
            let decoder = JSONDecoder()
            guard let matches = try? decoder.decode([RecentMatch].self, from: data) else {
                return
            }
            completion(matches)
            
        }
    }
    
    static func loadUserProfile(id: String, completion: @escaping (UserProfile) -> Void) {
        let profileURL = "\(baseURL)/api/players/\(id)"
        AF.request(profileURL).responseJSON { response in
            guard let data = response.data else {
                return
            }
            let decoder = JSONDecoder()
            guard let profile = try? decoder.decode(SteamProfile.self, from: data) else {
                return
            }
            completion(profile.profile)
        }
    }
}
