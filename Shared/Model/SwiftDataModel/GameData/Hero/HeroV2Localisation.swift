//
//  HeroV2Localisation.swift
//  D2A
//
//  Created by Shibo Tong on 6/9/2024.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
class HeroV2Localisation {
    
    var localisation: String
    
    var displayName: String
    
    var hero: HeroV2?
    
    init(localisation: String, displayName: String, hero: HeroV2? = nil) {
        self.localisation = localisation
        self.displayName = displayName
        self.hero = hero
    }
}
