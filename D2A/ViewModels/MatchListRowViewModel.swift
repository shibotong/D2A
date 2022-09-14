//
//  MatchListRowViewModel.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import UIKit

class MatchListRowViewModel: ObservableObject {
    @Published var match: RecentMatch
    
    init(match: RecentMatch) {
        self.match = match
    }
    
    init() {
        self.match = RecentMatch.sample.last!
    }
}
