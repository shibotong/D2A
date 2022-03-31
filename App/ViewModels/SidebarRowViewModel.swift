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
    
    func loadProfile() {
        guard let profile = WCDBController.shared.fetchUserProfile(userid: userid) else {
            Task {
                let profile = await OpenDotaController.shared.loadUserData(userid: userid)
                self.profile = profile
            }
            return
        }
        self.profile = profile
    }
}
