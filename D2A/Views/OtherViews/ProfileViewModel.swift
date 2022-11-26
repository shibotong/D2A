//
//  ProfileViewModel.swift
//  App
//
//  Created by Shibo Tong on 21/8/21.
//

import Foundation
import UIKit

class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?
    @Published var isloading = false

    @Published var profileIcon: UIImage?

    var userid: String

    ///Init with userID
    ///- parameter id: Player ID
    init(id: String) {
        self.userid = id
        Task {
            await self.loadProfile()
        }
    }

    ///Init with User Profile
    ///- parameter profile: User Profile
    init(profile: UserProfile) {
        self.profile = profile
        self.userid = profile.id.description
        Task {
            try? await self.loadProfileImage(profile: profile)
        }
    }
    
    init(profile: UserProfileCodable) {
        let newProfile = UserProfile.create(profile)
        self.profile = newProfile
        self.userid = profile.id.description
        Task {
            try? await self.loadProfileImage(profile: newProfile)
        }
    }
    
    func loadProfile() async {
        self.isloading = true
        guard let profile = UserProfile.fetch(id: Int(userid)) else {
            guard let profile = await OpenDotaController.shared.loadUserData(userid: userid) else {
                return
            }
            let newProfile = UserProfile.create(profile)
            await self.setProfile(profile: newProfile)
            try? await self.loadProfileImage(profile: newProfile)
            return
        }
        await setProfile(profile: profile)
        try? await loadProfileImage(profile: profile)
    }

    private func loadProfileImage(profile: UserProfile?) async throws {
        guard let profile = profile else {
            return
        }
        guard let imageLink = URL(string: profile.avatarfull ?? "") else {
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
    
    @MainActor private func setProfile(profile: UserProfile?) {
        self.profile = profile
        self.isloading = false
    }
}
