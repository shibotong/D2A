//
//  MatchListViewModel.swift
//  App
//
//  Created by Shibo Tong on 11/8/21.
//

import Foundation
import UIKit

class MatchListRowViewModel: ObservableObject {
    @Published var heroName: String = ""
    @Published var match: RecentMatch
    @Published var hero: Hero?
    
    init(match: RecentMatch) {
        self.match = match
        
        self.hero = HeroDatabase.shared.fetchHeroWithID(id: Int(match.heroID))
    }
    
    init() {
        self.match = RecentMatch.sample.last!
    }
}
