//
//  SidebarRowViewModel.swift
//  App
//
//  Created by Shibo Tong on 17/8/21.
//

import Foundation
import CoreData

class SidebarRowViewModel: ObservableObject {
    @Published var profile: UserProfile?
    var userid: String
    
    init(userid: String) {
        self.userid = userid
        self.loadProfile()
    }
    
    private func loadProfile() {
        guard let profile = WCDBController.shared.fetchUserProfile(userid: userid) else {
            OpenDotaController.loadUserData(userid: userid) { steamProfile in
                self.loadProfile()
            }
            return
        }
        self.profile = profile
    }
}
