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

    @Published var personaname: String
    @Published var userID: String
    @Published var avatarfull: String

    /// Init with User Profile
    /// - parameter profile: User Profile
    init(profile: UserProfile) {
        self.profile = profile
        personaname = profile.personaname ?? ""
        userID = profile.userID.description
        avatarfull = profile.avatarfull ?? ""
    }

    init(profile: ODUserProfile) {
        personaname = profile.personaname
        userID = profile.id.description
        avatarfull = profile.avatarfull
    }
}
