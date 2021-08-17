//
//  SidebarRowViewModel.swift
//  App
//
//  Created by Shibo Tong on 17/8/21.
//

import Foundation

class SidebarRowViewModel: ObservableObject {
    @Published var profile: SteamProfile?
    var userid: String
    
    init(userid: String) {
        self.userid = userid
        self.loadProfile()
    }
    
    private func loadProfile() {
        OpenDotaController.loadUserData(userid: userid) { profile in
            self.profile = profile
        }
    }
}
