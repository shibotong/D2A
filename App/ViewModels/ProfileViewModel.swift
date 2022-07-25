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
        self.profile = UserProfile.sample
        self.userid = "123"
    }
    
    func loadProfile() async {
        self.isloading = true
        guard let profile = WCDBController.shared.fetchUserProfile(userid: userid) else {
            let profile = await OpenDotaController.shared.loadUserData(userid: userid)
            await self.setProfile(profile: profile)
            try? await self.loadProfileImage(profile: profile)
            return
        }
        await setProfile(profile: profile)
        try? await loadProfileImage(profile: profile)
    }

    private func loadProfileImage(profile: UserProfile?) async throws {
        guard let profile = profile else {
            return
        }
        guard let imageLink = URL(string: profile.avatarfull) else {
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
