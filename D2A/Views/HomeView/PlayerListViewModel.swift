//
//  PlayerListViewModel.swift
//  App
//
//  Created by Shibo Tong on 10/6/2022.
//

import Foundation

class PlayerListViewModel: ObservableObject {
    @Published var userIDs: [String]
    
    @Published var registerdID: String
    
    init(registeredID: String, followedID: [String]) {
        self.registerdID = registeredID
        self.userIDs = followedID
    }
}
