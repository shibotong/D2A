//
//  ProfileViewModel.swift
//  App
//
//  Created by Shibo Tong on 21/8/21.
//

import Foundation

class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var isloading = false
    var userid: String
    
    init(id: String) {
        self.userid = id
        Task {
            await self.loadProfile()
        }
    }
    
    init(profile: UserProfile) {
        self.profile = profile
        self.userid = profile.id.description
    }
    
    init() {
        self.profile = SteamProfile.sample.profile
        self.userid = "123"
    }
    
    func loadProfile() async {
        self.isloading = true
        guard let profile = WCDBController.shared.fetchUserProfile(userid: userid) else {
            let profile = await OpenDotaController.shared.loadUserData(userid: userid)
            await self.setProfile(profile: profile)
            return
        }
        await setProfile(profile: profile)
    }
    
    @MainActor private func setProfile(profile: UserProfile?) {
        self.profile = profile
        self.isloading = false
    }
}
