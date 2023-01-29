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
    
    @Published var profile: UserProfile?

    ///Init with userID
    ///- parameter id: Player ID
    init(id: String) {
        if id != "0" {
            Task {
                await self.loadProfile(userid: id)
            }
        }
    }
    
    ///Init with User Profile
    ///- parameter profile: User Profile
    init(profile: UserProfile) {
        self.profile = profile
    }
    
    init(profile: UserProfileCodable) {
        self.profile = try? UserProfile.create(profile)
    }
    
    private func loadProfile(userid: String) async {
        
        // Check if CoreData has UserProfile
        if let profile = UserProfile.fetch(id: userid) {
            await setProfile(profile: profile)
            return
        }
        
        await setLoading(true)
        if let profileCodable = try? await OpenDotaController.shared.loadUserData(userid: userid) {
            _ = try? UserProfile.create(profileCodable)
            if let profile = UserProfile.fetch(id: userid) {
                await setProfile(profile: profile)
            }
        }
        await setLoading(false)
    }
    
    @MainActor
    private func setProfile(profile: UserProfile) async {
        self.profile = profile
    }
    
    @MainActor
    private func setLoading(_ isLoading: Bool) async {
        isloading = isLoading
    }
}
