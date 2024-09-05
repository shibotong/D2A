//
//  HeroV2Role.swift
//  D2A
//
//  Created by Shibo Tong on 6/9/2024.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
class HeroV2Role {
    
    var roleId: String
    var level: Double
    
    var hero: HeroV2?
    
    init(roleId: String, level: Double, hero: HeroV2? = nil) {
        self.roleId = roleId
        self.level = level
        self.hero = hero
    }
}
