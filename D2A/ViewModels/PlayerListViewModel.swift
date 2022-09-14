//
//  PlayerListViewModel.swift
//  App
//
//  Created by Shibo Tong on 10/6/2022.
//

import Foundation

class PlayerListViewModel: ObservableObject {
    @Published var registerdID: String
    @Published var userIDs: [String]
    
    init(registeredID: String, followedID: [String]) {
        self.registerdID = registeredID
        self.userIDs = followedID
    }
}
