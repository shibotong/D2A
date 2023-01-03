//
//  MatchListRowViewModel.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import UIKit

class MatchListRowViewModel: ObservableObject {
    @Published var match: RecentMatchCodable
    
    init(match: RecentMatchCodable) {
        self.match = match
    }
    
    init() {
        self.match = RecentMatchCodable.sample.last!
    }
}
