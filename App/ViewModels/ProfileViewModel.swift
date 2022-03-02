//
//  ProfileViewModel.swift
//  App
//
//  Created by Shibo Tong on 21/8/21.
//

import Foundation
import Alamofire

class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile?
    @Published var isloading = false
    var userid: String
    
    init(id: String) {
        self.userid = id
        self.searchUser()
    }
    
    init(profile: UserProfile) {
        self.userProfile = profile
        self.userid = profile.id.description
    }
    
    init() {
        self.userProfile = SteamProfile.sample.profile
        self.userid = "123"
    }
    
    func searchUser() {
        isloading = true
        let url = "\(baseURL)/api/players/\(userid)"
        AF.request(url).responseJSON { response in
            guard let data = response.data else {
                DispatchQueue.main.async {
                    self.isloading = false
                }
                return
            }
            guard let statusCode = response.response?.statusCode else {
                DispatchQueue.main.async {
                    self.isloading = false
                }
                return
            }
            if statusCode == 500 {
                DispatchQueue.main.async {
                    self.isloading = false
                }
                return
            }
//            if statusCode > 400 {
//                DotaEnvironment.shared.exceedLimit = true
//                return
//            }
            let decoder = JSONDecoder()
            
            let user = try? decoder.decode(SteamProfile.self, from: data)
            DispatchQueue.main.async {
                self.userProfile = user?.profile
                self.isloading = false
            }
        }
    }
}
