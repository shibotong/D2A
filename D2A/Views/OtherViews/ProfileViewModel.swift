//
//  ProfileViewModel.swift
//  App
//
//  Created by Shibo Tong on 21/8/21.
//

import Foundation
import UIKit

class ProfileViewModel: ObservableObject {
    @Published var isloading = false

    @Published var urlString: String?
    
    @Published var personaname: String?

    var userid: String

    ///Init with userID
    ///- parameter id: Player ID
    init(id: String) {
        self.userid = id
        if id != "0" {
            Task {
                await self.loadProfile()
            }
        }
    }

    ///Init with User Profile
    ///- parameter profile: User Profile
    init(profile: UserProfile) {
        self.personaname = profile.personaname ?? ""
        self.userid = profile.id.description
        self.urlString = profile.avatarfull
    }
    
    init(profile: UserProfileCodable) {
        self.personaname = profile.personaname
        self.userid = profile.id.description
        self.urlString = profile.avatarfull
    }
    
    func loadProfile() async {
        self.isloading = true
        guard let profile = UserProfile.fetch(id: Int(userid)) else {
            guard let profile = await OpenDotaController.shared.loadUserData(userid: userid) else {
                return
            }
            await self.setProfile(name: profile.personaname, image: profile.avatarfull)
            return
        }
        await setProfile(name: profile.personaname, image: profile.avatarfull)
    }
    
    @MainActor private func setProfile(name: String?, image: String?) {
        self.personaname = name ?? ""
        self.urlString = image
        self.isloading = false
    }
}
