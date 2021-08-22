//
//  ProfileViewModel.swift
//  App
//
//  Created by Shibo Tong on 21/8/21.
//

import Foundation
import Alamofire

class ProfileViewModel: ObservableObject {
    @Published var steamProfile: SteamProfile?
    @Published var isloading = false
    var userid: String
    
    init(id: String) {
        self.userid = id
        self.searchUser()
    }
    
    func searchUser() {
        isloading = true
        let url = "\(baseURL)/api/players/\(userid)"
        AF.request(url).responseJSON { response in
            print("search user data")
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
            DispatchQueue.main.async {
                self.steamProfile = user
                self.isloading = false
            }
        }
    }
}
