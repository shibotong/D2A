//
//  Environment.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation

class DotaEnvironment: ObservableObject {
    
    @Published var loading = false
    
    @Published var userID = "153041957"
    
    init() {
//        self.loading = true
//        OpenDotaController.loadRecentMatch(userid: "153041957") { matches in
//            self.recentMatches = matches
//            DispatchQueue.main.async {
//                self.loading = false
//            }
//        }
    }
}
