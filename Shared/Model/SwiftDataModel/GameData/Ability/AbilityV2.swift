//
//  AbilityV2.swift
//  D2A
//
//  Created by Shibo Tong on 1/9/2024.
//

import Foundation
import SwiftData

@available(iOS 17, *)
@Model
class AbilityV2 {
    
    @Attribute(.unique)
    var abilityID: Int
    
    ///ability name
    var name: String
    
    ///ability display name
    var dname: String?
    
    var imageURL: String?
    var behaviour: String?
    var targetTeam: String?
    var targetType: String?
    var dmgType: String?
    
    var mc: String?
    var cd: String?
    var bkbPierce: String?
    var dispellable: String?
    var lore: String?
    
    var hero: HeroV2?
    
    @Relationship(deleteRule: .cascade, inverse: \AbilityV2Attribute.ability)
    var attributes: [AbilityV2Attribute] = []
    
    @Relationship(deleteRule: .cascade, inverse: \AbilityV2Localisation.ability)
    var localisations: [AbilityV2Localisation] = []
    
    init(abilityID: Int, 
         name: String,
         dname: String? = nil,
         imageURL: String? = nil,
         behaviour: String? = nil,
         targetTeam: String? = nil,
         targetType: String? = nil,
         dmgType: String? = nil,
         mc: String? = nil,
         cd: String? = nil,
         bkbPierce: String? = nil,
         dispellable: String? = nil) {
        self.abilityID = abilityID
        self.name = name
        self.dname = dname
        self.imageURL = imageURL
        self.behaviour = behaviour
        self.targetTeam = targetTeam
        self.targetType = targetType
        self.dmgType = dmgType
        self.mc = mc
        self.cd = cd
        self.bkbPierce = bkbPierce
        self.dispellable = dispellable
    }
}
