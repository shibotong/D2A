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
//        self.loadProfile()
    }
    
    init(profile: UserProfile) {
        self.userProfile = profile
        self.userid = profile.id.description
    }
    
    init() {
        self.userProfile = SteamProfile.sample.profile
        self.userid = "123"
    }
    
//    func loadProfile() {
//        guard let profile = WCDBController.shared.fetchUserProfile(userid: userid) else {
//            Task {
//                if isRegistered {
//                    let profile = await OpenDotaController.shared.loadUserData(userid: userid)
//                    let match = await OpenDotaController.shared.loadLatestMatch(userid: userid)
//                    await self.setProfile(profile, match: match)
//                } else {
//                    let profile = await OpenDotaController.shared.loadUserData(userid: userid)
//                    await self.setProfile(profile)
//                }
//            }
//            return
//        }
//        self.profile = profile
//    }
}
