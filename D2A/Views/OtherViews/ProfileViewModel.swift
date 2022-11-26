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

    @Published var profileIcon: UIImage?
    
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
        Task {
            try? await self.loadProfileImage(url: profile.avatarfull)
        }
    }
    
    init(profile: UserProfileCodable) {
        self.personaname = profile.personaname
        self.userid = profile.id.description
        Task {
            try? await self.loadProfileImage(url: profile.avatarfull)
        }
    }
    
    func loadProfile() async {
        self.isloading = true
        guard let profile = UserProfile.fetch(id: Int(userid)) else {
            guard let profile = await OpenDotaController.shared.loadUserData(userid: userid) else {
                return
            }
            await self.setProfile(name: profile.personaname)
            try? await self.loadProfileImage(url: profile.avatarfull)
            return
        }
        await setProfile(name: profile.personaname)
        try? await loadProfileImage(url: profile.avatarfull)
    }

    private func loadProfileImage(url: String?) async throws {
        guard let imageLink = URL(string: url ?? "") else {
            return
        }
        let (imageData, _) = try await URLSession.shared.data(from: imageLink)
        guard let profileImage = UIImage(data: imageData) else {
            return
        }
        await self.setImage(profileImage)
    }
    
    @MainActor private func setImage(_ image: UIImage) {
        self.profileIcon = image
    }
    
    @MainActor private func setProfile(name: String?) {
        self.personaname = name ?? ""
        self.isloading = false
    }
}
