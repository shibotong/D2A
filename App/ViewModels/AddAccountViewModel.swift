//
//  AddAccountViewModel.swift
//  App
//
//  Created by Shibo Tong on 20/8/21.
//

import Foundation
import Combine

class AddAccountViewModel: ObservableObject {
    @Published var userid: String = ""
    @Published var searched = false
    @Published var searchUserId: String = ""
    private var cancellableObject: Set<AnyCancellable> = []
    init() {
//        $userid
//            .receive(on: RunLoop.main)
//            .map { userid in
//                return false
//            }
//            .assign(to: \.searched, on: self)
//            .store(in: &cancellableObject)
    }
}
