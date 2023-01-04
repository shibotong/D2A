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
        userid = id
        if id != "0" {
            Task {
                await loadProfile()
            }
        }
    }

    ///Init with User Profile
    ///- parameter profile: User Profile
    init(profile: UserProfile) {
        personaname = profile.personaname ?? ""
        userid = profile.id ?? ""
        urlString = profile.avatarfull
    }
    
    init(profile: UserProfileCodable) {
        personaname = profile.personaname
        userid = profile.id.description
        urlString = profile.avatarfull
    }
    
    func loadProfile() async {
        isloading = true
        guard let profile = UserProfile.fetch(id: userid) else {
            guard let profile = try? await OpenDotaController.shared.loadUserData(userid: userid) else {
                return
            }
            await setProfile(name: profile.personaname, image: profile.avatarfull)
            return
        }
        await setProfile(name: profile.personaname, image: profile.avatarfull)
    }
    
    @MainActor private func setProfile(name: String?, image: String?) {
        personaname = name ?? ""
        urlString = image
        isloading = false
    }
}
